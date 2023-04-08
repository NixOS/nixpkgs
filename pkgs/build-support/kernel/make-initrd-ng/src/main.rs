use std::collections::{HashSet, VecDeque};
use std::env;
use std::ffi::{OsStr, OsString};
use std::fs;
use std::hash::Hash;
use std::iter::FromIterator;
use std::io::{BufRead, BufReader, Error};
use std::os::unix;
use std::path::{Component, Path, PathBuf};
use std::process::Command;

use goblin::{elf::Elf, Object};

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

fn add_dependencies<P: AsRef<Path> + AsRef<OsStr>>(
    source: P,
    elf: Elf,
    queue: &mut NonRepeatingQueue<Box<Path>>,
) {
    if let Some(interp) = elf.interpreter {
        queue.push_back(Box::from(Path::new(interp)));
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

    for line in elf.libraries {
        let mut found = false;
        for path in &rpaths_as_path {
            let lib = path.join(line);
            if lib.exists() {
                // No need to recurse. The queue will bring it back round.
                queue.push_back(Box::from(lib.as_path()));
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
}

fn copy_file<P: AsRef<Path> + AsRef<OsStr>, S: AsRef<Path> + AsRef<OsStr>>(
    source: P,
    target: S,
    queue: &mut NonRepeatingQueue<Box<Path>>,
) -> Result<(), Error> {
    fs::copy(&source, &target)?;

    let contents = fs::read(&source)?;

    if let Ok(Object::Elf(e)) = Object::parse(&contents) {
        add_dependencies(source, e, queue);

        // Make file writable to strip it
        let mut permissions = fs::metadata(&target)?.permissions();
        permissions.set_readonly(false);
        fs::set_permissions(&target, permissions)?;

        // Strip further than normal
        if let Ok(strip) = env::var("STRIP") {
            if !Command::new(strip)
                .arg("--strip-all")
                .arg(OsStr::new(&target))
                .output()?
                .status
                .success()
            {
                println!("{:?} was not successfully stripped.", OsStr::new(&target));
            }
        }
    };

    Ok(())
}

fn queue_dir<P: AsRef<Path>>(
    source: P,
    queue: &mut NonRepeatingQueue<Box<Path>>,
) -> Result<(), Error> {
    for entry in fs::read_dir(source)? {
        let entry = entry?;
        // No need to recurse. The queue will bring us back round here on its own.
        queue.push_back(Box::from(entry.path().as_path()));
    }

    Ok(())
}

fn handle_path(
    root: &Path,
    p: &Path,
    queue: &mut NonRepeatingQueue<Box<Path>>,
) -> Result<(), Error> {
    let mut source = PathBuf::new();
    let mut target = Path::new(root).to_path_buf();
    let mut iter = p.components().peekable();
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
                let typ = fs::symlink_metadata(&source)?.file_type();
                if typ.is_file() && !target.exists() {
                    copy_file(&source, &target, queue)?;

                    if let Some(filename) = source.file_name() {
                        source.set_file_name(OsString::from_iter([
                                OsStr::new("."),
                                filename,
                                OsStr::new("-wrapped"),
                        ]));

                        let wrapped_path = source.as_path();
                        if wrapped_path.exists() {
                            queue.push_back(Box::from(wrapped_path));
                        }
                    }
                } else if typ.is_symlink() {
                    let link_target = fs::read_link(&source)?;

                    // Create the link, then push its target to the queue
                    if !target.exists() {
                        unix::fs::symlink(&link_target, &target)?;
                    }
                    source.pop();
                    source.push(link_target);
                    while let Some(c) = iter.next() {
                        source.push(c);
                    }
                    let link_target_path = source.as_path();
                    if link_target_path.exists() {
                        queue.push_back(Box::from(link_target_path));
                    }
                    break;
                } else if typ.is_dir() {
                    if !target.exists() {
                        fs::create_dir(&target)?;
                    }

                    // Only recursively copy if the directory is the target object
                    if iter.peek().is_none() {
                        queue_dir(&source, queue)?;
                    }
                }
            }
        }
    }

    Ok(())
}

fn main() -> Result<(), Error> {
    let args: Vec<String> = env::args().collect();
    let input = fs::File::open(&args[1])?;
    let output = &args[2];
    let out_path = Path::new(output);

    let mut queue = NonRepeatingQueue::<Box<Path>>::new();

    let mut lines = BufReader::new(input).lines();
    while let Some(obj) = lines.next() {
        // Lines should always come in pairs
        let obj = obj?;
        let sym = lines.next().unwrap()?;

        let obj_path = Path::new(&obj);
        queue.push_back(Box::from(obj_path));
        if !sym.is_empty() {
            println!("{} -> {}", &sym, &obj);
            // We don't care about preserving symlink structure here
            // nearly as much as for the actual objects.
            let link_string = format!("{}/{}", output, sym);
            let link_path = Path::new(&link_string);
            let mut link_parent = link_path.to_path_buf();
            link_parent.pop();
            fs::create_dir_all(link_parent)?;
            unix::fs::symlink(obj_path, link_path)?;
        }
    }
    while let Some(obj) = queue.pop_front() {
        handle_path(out_path, &*obj, &mut queue)?;
    }

    Ok(())
}
