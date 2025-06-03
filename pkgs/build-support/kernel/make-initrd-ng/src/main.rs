use std::collections::{BTreeSet, HashSet, VecDeque};
use std::env;
use std::ffi::{OsStr, OsString};
use std::fs;
use std::hash::Hash;
use std::iter::FromIterator;
use std::os::unix;
use std::os::unix::fs::PermissionsExt;
use std::path::{Component, Path, PathBuf};
use std::process::Command;

use libc::umask;

use eyre::Context;
use goblin::{elf::Elf, Object};
use serde::Deserialize;

#[derive(PartialEq, Eq, PartialOrd, Ord, Clone, Copy, Debug, Deserialize, Hash)]
#[serde(rename_all = "lowercase")]
enum DLOpenPriority {
    Required,
    Recommended,
    Suggested,
}

#[derive(PartialEq, Eq, Debug, Deserialize, Clone, Hash)]
#[serde(rename_all = "camelCase")]
struct DLOpenConfig {
    use_priority: DLOpenPriority,
    features: BTreeSet<String>,
}

#[derive(Deserialize, Debug)]
struct DLOpenNote {
    soname: Vec<String>,
    feature: Option<String>,
    // description is in the spec, but we don't need it here.
    // description: Option<String>,
    priority: Option<DLOpenPriority>,
}

#[derive(Deserialize, Debug, PartialEq, Eq, Hash, Clone)]
struct StoreInput {
    source: String,
    target: Option<String>,
    dlopen: Option<DLOpenConfig>,
}

#[derive(PartialEq, Eq, Hash, Clone)]
struct StorePath {
    path: Box<Path>,
    dlopen: Option<DLOpenConfig>,
}

struct NonRepeatingQueue<T> {
    queue: VecDeque<T>,
    seen: HashSet<T>,
}

impl<T> NonRepeatingQueue<T> {
    fn new() -> NonRepeatingQueue<T> {
        NonRepeatingQueue {
            queue: VecDeque::new(),
            seen: HashSet::new(),
        }
    }
}

impl<T: Clone + Eq + Hash> NonRepeatingQueue<T> {
    fn push_back(&mut self, value: T) -> bool {
        if self.seen.contains(&value) {
            false
        } else {
            self.seen.insert(value.clone());
            self.queue.push_back(value);
            true
        }
    }

    fn pop_front(&mut self) -> Option<T> {
        self.queue.pop_front()
    }
}

fn add_dependencies<P: AsRef<Path> + AsRef<OsStr> + std::fmt::Debug>(
    source: P,
    elf: Elf,
    contents: &[u8],
    dlopen: &Option<DLOpenConfig>,
    queue: &mut NonRepeatingQueue<StorePath>,
) -> eyre::Result<()> {
    if let Some(interp) = elf.interpreter {
        queue.push_back(StorePath {
            path: Box::from(Path::new(interp)),
            dlopen: dlopen.clone(),
        });
    }

    let mut dlopen_libraries = vec![];
    if let Some(dlopen) = dlopen {
        for n in elf
            .iter_note_sections(&contents, Some(".note.dlopen"))
            .into_iter()
            .flatten()
        {
            let note = n.wrap_err_with(|| format!("bad note in {:?}", source))?;
            // Payload is padded and zero terminated
            let payload = &note.desc[..note
                .desc
                .iter()
                .position(|x| *x == 0)
                .unwrap_or(note.desc.len())];
            let parsed = serde_json::from_slice::<Vec<DLOpenNote>>(payload)?;
            for mut parsed_note in parsed {
                if dlopen.use_priority
                    >= parsed_note.priority.unwrap_or(DLOpenPriority::Recommended)
                    || parsed_note
                        .feature
                        .map(|f| dlopen.features.contains(&f))
                        .unwrap_or(false)
                {
                    dlopen_libraries.append(&mut parsed_note.soname);
                }
            }
        }
    }

    let rpaths = if elf.runpaths.len() > 0 {
        elf.runpaths
    } else if elf.rpaths.len() > 0 {
        elf.rpaths
    } else {
        vec![]
    };

    let rpaths_as_path = rpaths
        .into_iter()
        .flat_map(|p| p.split(":"))
        .map(|p| Box::<Path>::from(Path::new(p)))
        .collect::<Vec<_>>();

    for line in elf
        .libraries
        .into_iter()
        .map(|s| s.to_string())
        .chain(dlopen_libraries)
    {
        let mut found = false;
        for path in &rpaths_as_path {
            let lib = path.join(&line);
            if lib.exists() {
                // No need to recurse. The queue will bring it back round.
                queue.push_back(StorePath {
                    path: Box::from(lib.as_path()),
                    dlopen: dlopen.clone(),
                });
                found = true;
                break;
            }
        }
        if !found {
            // glibc makes it tricky to make this an error because
            // none of the files have a useful rpath.
            println!(
                "Warning: Couldn't satisfy dependency {} for {:?}",
                line,
                OsStr::new(&source)
            );
        }
    }

    Ok(())
}

fn copy_file<
    P: AsRef<Path> + AsRef<OsStr> + std::fmt::Debug,
    S: AsRef<Path> + AsRef<OsStr> + std::fmt::Debug,
>(
    source: P,
    target: S,
    dlopen: &Option<DLOpenConfig>,
    queue: &mut NonRepeatingQueue<StorePath>,
) -> eyre::Result<()> {
    fs::copy(&source, &target)
        .wrap_err_with(|| format!("failed to copy {:?} to {:?}", source, target))?;

    let contents =
        fs::read(&source).wrap_err_with(|| format!("failed to read from {:?}", source))?;

    if let Ok(Object::Elf(e)) = Object::parse(&contents) {
        add_dependencies(source, e, &contents, &dlopen, queue)?;
    };

    Ok(())
}

fn queue_dir<P: AsRef<Path> + std::fmt::Debug>(
    source: P,
    dlopen: &Option<DLOpenConfig>,
    queue: &mut NonRepeatingQueue<StorePath>,
) -> eyre::Result<()> {
    for entry in
        fs::read_dir(&source).wrap_err_with(|| format!("failed to read dir {:?}", source))?
    {
        let entry = entry?;
        // No need to recurse. The queue will bring us back round here on its own.
        queue.push_back(StorePath {
            path: Box::from(entry.path().as_path()),
            dlopen: dlopen.clone(),
        });
    }

    Ok(())
}

fn handle_path(
    root: &Path,
    p: StorePath,
    queue: &mut NonRepeatingQueue<StorePath>,
) -> eyre::Result<()> {
    let mut source = PathBuf::new();
    let mut target = Path::new(root).to_path_buf();
    let mut iter = p.path.components().peekable();
    while let Some(comp) = iter.next() {
        match comp {
            Component::Prefix(_) => panic!("This tool is not meant for Windows"),
            Component::RootDir => {
                target.clear();
                target.push(root);
                source.clear();
                source.push("/");
            }
            Component::CurDir => {}
            Component::ParentDir => {
                // Don't over-pop the target if the path has too many ParentDirs
                if source.pop() {
                    target.pop();
                }
            }
            Component::Normal(name) => {
                target.push(name);
                source.push(name);
                let typ = fs::symlink_metadata(&source)
                    .wrap_err_with(|| format!("failed to get symlink metadata for {:?}", source))?
                    .file_type();
                if typ.is_file() && !target.exists() {
                    copy_file(&source, &target, &p.dlopen, queue)?;

                    if let Some(filename) = source.file_name() {
                        source.set_file_name(OsString::from_iter([
                            OsStr::new("."),
                            filename,
                            OsStr::new("-wrapped"),
                        ]));

                        let wrapped_path = source.as_path();
                        if wrapped_path.exists() {
                            queue.push_back(StorePath {
                                path: Box::from(wrapped_path),
                                dlopen: p.dlopen.clone(),
                            });
                        }
                    }
                } else if typ.is_symlink() {
                    let link_target = fs::read_link(&source)
                        .wrap_err_with(|| format!("failed to resolve symlink of {:?}", source))?;

                    // Create the link, then push its target to the queue
                    if !target.exists() && !target.is_symlink() {
                        unix::fs::symlink(&link_target, &target).wrap_err_with(|| {
                            format!("failed to symlink {:?} to {:?}", link_target, target)
                        })?;
                    }
                    source.pop();
                    source.push(link_target);
                    while let Some(c) = iter.next() {
                        source.push(c);
                    }
                    let link_target_path = source.as_path();
                    if link_target_path.exists() {
                        queue.push_back(StorePath {
                            path: Box::from(link_target_path),
                            dlopen: p.dlopen.clone(),
                        });
                    }
                    break;
                } else if typ.is_dir() {
                    if !target.exists() {
                        fs::create_dir(&target)
                            .wrap_err_with(|| format!("failed to create dir {:?}", target))?;
                    }

                    // Only recursively copy if the directory is the target object
                    if iter.peek().is_none() {
                        queue_dir(&source, &p.dlopen, queue)
                            .wrap_err_with(|| format!("failed to queue dir {:?}", source))?;
                    }
                }
            }
        }
    }

    Ok(())
}

fn main() -> eyre::Result<()> {
    let args: Vec<String> = env::args().collect();
    let contents =
        fs::read(&args[1]).wrap_err_with(|| format!("failed to open file {:?}", &args[1]))?;
    let input = serde_json::from_slice::<Vec<StoreInput>>(&contents)
        .wrap_err_with(|| {
            let text = String::from_utf8_lossy(&contents);
            format!("failed to parse JSON '{}' in {:?}",
                text,
                &args[1])
        })?;
    let output = &args[2];
    let out_path = Path::new(output);

    // The files we create should not be writable.
    unsafe { umask(0o022) };

    let mut queue = NonRepeatingQueue::<StorePath>::new();

    for sp in input {
        let obj_path = Path::new(&sp.source);
        queue.push_back(StorePath {
            path: Box::from(obj_path),
            dlopen: sp.dlopen,
        });
        if let Some(target) = sp.target {
            println!("{} -> {}", &target, &sp.source);
            // We don't care about preserving symlink structure here
            // nearly as much as for the actual objects.
            let link_string = format!("{}/{}", output, target);
            let link_path = Path::new(&link_string);
            let mut link_parent = link_path.to_path_buf();
            link_parent.pop();
            fs::create_dir_all(&link_parent)
                .wrap_err_with(|| format!("failed to create directories to {:?}", link_parent))?;
            unix::fs::symlink(obj_path, link_path)
                .wrap_err_with(|| format!("failed to symlink {:?} to {:?}", obj_path, link_path))?;
        }
    }
    while let Some(obj) = queue.pop_front() {
        handle_path(out_path, obj, &mut queue)?;
    }

    Ok(())
}
