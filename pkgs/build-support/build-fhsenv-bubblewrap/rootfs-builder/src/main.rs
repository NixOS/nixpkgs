#![deny(clippy::pedantic)]

use std::{
    collections::{hash_map::Entry, HashMap},
    env,
    fs::{self, File},
    io::{BufReader, Read},
    os::unix::fs as ufs,
    path::{Path, PathBuf},
};

use anyhow::{anyhow, Context};
use goblin::{Hint, Object};
use serde::Deserialize;
use walkdir::WalkDir;

#[derive(Debug, Deserialize)]
struct RefGraphNode {
    path: PathBuf,
    references: Vec<PathBuf>,
}

#[derive(Debug, Deserialize)]
struct InputDrv {
    paths: Vec<PathBuf>,
    priority: i64,
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
struct StructuredAttrsRoot {
    graph: Vec<RefGraphNode>,
    paths: Vec<InputDrv>,
    paths32: Vec<InputDrv>,
    include_closures: bool,
}

#[derive(Copy, Clone, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct PriorityKey {
    implicit: bool,
    group_priority: i64,
    priority: i64,
    root_index: usize,
}

const FHSENV_MARKER_FILE: &str = "nix-support/is-fhsenv";

fn build_reference_map(refs: Vec<RefGraphNode>) -> HashMap<PathBuf, Vec<PathBuf>> {
    refs.into_iter()
        .map(|mut gn| {
            gn.references.retain_mut(|x| x != &gn.path);
            (gn.path, gn.references)
        })
        .collect()
}

fn build_priority_keys(roots: &[InputDrv], group_priority: i64) -> HashMap<PathBuf, PriorityKey> {
    let mut roots_map = HashMap::new();

    for (idx, path) in roots.iter().enumerate() {
        for subpath in &path.paths {
            let priority = PriorityKey {
                group_priority,
                priority: path.priority,
                root_index: idx,
                implicit: false,
            };

            roots_map.entry(subpath.clone()).or_insert(priority);
        }
    }

    roots_map
}

fn extend_to_closure(
    roots: HashMap<PathBuf, PriorityKey>,
    refs: &HashMap<PathBuf, Vec<PathBuf>>,
) -> anyhow::Result<HashMap<PathBuf, PriorityKey>> {
    let mut path_map = HashMap::new();

    for (root, priority) in roots {
        path_map.insert(root.clone(), priority);

        let mut priority = priority;
        priority.implicit = true;

        let mut stack = vec![root.clone()];

        while let Some(next) = stack.pop() {
            match path_map.entry(next.clone()) {
                Entry::Occupied(mut occupied_entry) => {
                    let old_priority: &PriorityKey = occupied_entry.get();
                    if old_priority > &priority {
                        occupied_entry.insert(priority);
                    }
                }
                Entry::Vacant(vacant_entry) => {
                    vacant_entry.insert(priority);
                }
            }

            stack.extend_from_slice(refs.get(&next).ok_or(anyhow!("encountered unknown path"))?);
        }
    }

    Ok(path_map)
}

#[derive(Clone, Debug)]
struct CandidatePath {
    root: PathBuf,
    relative: PathBuf,
    priority: PriorityKey,
}

fn collect_candidate_paths(
    paths: HashMap<PathBuf, PriorityKey>,
    mapper: impl Fn(&Path, &Path) -> Option<PathBuf>,
) -> anyhow::Result<HashMap<PathBuf, Vec<CandidatePath>>> {
    let mut candidates: HashMap<_, Vec<_>> = HashMap::new();

    for (path, priority) in paths {
        if path.join(FHSENV_MARKER_FILE).exists() {
            // is another fhsenv, skip it
            continue;
        }

        for entry in WalkDir::new(&path).follow_links(true) {
            let entry: PathBuf = match entry {
                Ok(ent) => {
                    // we don't care about directory structure
                    if ent.file_type().is_dir() {
                        continue;
                    }

                    ent.path().into()
                }
                Err(e) => {
                    match e.io_error() {
                        // could be a broken symlink, that's fine, we still want to handle those
                        Some(_) => e
                            .path()
                            .ok_or_else(|| anyhow!("I/O error when walking {}", path.display()))?
                            .into(),
                        None => {
                            // symlink loop
                            continue;
                        }
                    }
                }
            };

            let relative = entry.strip_prefix(&path)?.to_owned();
            if let Some(mapped) = mapper(&path, &relative) {
                candidates.entry(mapped).or_default().push(CandidatePath {
                    root: path.clone(),
                    relative,
                    priority,
                });
            }
        }
    }

    Ok(candidates)
}

fn remap_native_path(root: &Path, p: &Path) -> Option<PathBuf> {
    if p.starts_with("bin/") || p.starts_with("sbin/") || p.starts_with("libexec/") {
        return Some(PathBuf::from("usr/").join(p));
    }

    // glibc-multilib special case
    if let Ok(no_lib32) = p.strip_prefix("lib/32/") {
        return Some(PathBuf::from("usr/lib32/").join(no_lib32));
    }

    remap_multilib_path(root, p)
}

fn is_32_bit(path: &Path) -> bool {
    // Be as pessimistic as possible, at least for now.
    let Ok(mut f) = File::open(path) else {
        return false;
    };

    let Ok(Hint::Elf(hint)) = goblin::peek(&mut f) else {
        return false;
    };

    if let Some(is64) = hint.is_64 {
        return !is64;
    }

    let mut buf = vec![];
    let Ok(_) = f.read_to_end(&mut buf) else {
        return false;
    };

    let Ok(Object::Elf(e)) = goblin::Object::parse(&buf) else {
        return false;
    };

    !e.is_64
}

fn remap_multilib_path(root: &Path, p: &Path) -> Option<PathBuf> {
    if let Ok(no_lib) = p.strip_prefix("lib/") {
        let full = root.join(p);

        let libdir = if is_32_bit(&full) { "lib32" } else { "lib64" };

        return Some(PathBuf::from("usr/").join(libdir).join(no_lib));
    }

    if p.starts_with("etc/") || p.starts_with("opt/") {
        return Some(p.into());
    }

    if p.starts_with("share/") || p.starts_with("include/") {
        return Some(PathBuf::from("usr/").join(p));
    }

    None
}

fn build_plan(
    paths: HashMap<PathBuf, PriorityKey>,
    paths32: HashMap<PathBuf, PriorityKey>,
) -> anyhow::Result<HashMap<PathBuf, PathBuf>> {
    let candidates_native = collect_candidate_paths(paths, remap_native_path)?;
    let candidates_32 = collect_candidate_paths(paths32, remap_multilib_path)?;

    let mut all_candidates: HashMap<_, Vec<_>> = HashMap::new();

    for map in [candidates_native, candidates_32] {
        for (path, candidates) in map {
            all_candidates
                .entry(path)
                .or_default()
                .extend_from_slice(&candidates);
        }
    }

    let mut final_plan: HashMap<PathBuf, PathBuf> = HashMap::new();
    for (path, candidates) in all_candidates {
        let best = candidates
            .into_iter()
            .min_by_key(|&CandidatePath { priority, .. }| priority)
            .ok_or(anyhow!("candidate list empty"))?;
        final_plan.insert(path, best.root.join(best.relative));
    }

    Ok(final_plan)
}

fn build_env(out: &Path, plan: HashMap<PathBuf, PathBuf>) -> anyhow::Result<()> {
    fs::create_dir_all(out)?;

    for (dest, src) in plan {
        let full_dest = out.join(&dest);
        let dest_dir = full_dest
            .parent()
            .ok_or(anyhow!("destination directory is root"))
            .with_context(|| {
                format!(
                    "When trying to determine destination directory for {}",
                    full_dest.display()
                )
            })?;
        fs::create_dir_all(dest_dir)
            .with_context(|| format!("When trying to create directory {}", dest_dir.display()))?;
        ufs::symlink(&src, &full_dest).with_context(|| {
            format!(
                "When symlinking {} to {}",
                src.display(),
                full_dest.display()
            )
        })?;
    }

    let marker = out.join(FHSENV_MARKER_FILE);
    fs::create_dir_all(
        marker
            .parent()
            .ok_or(anyhow!("marker file is in root, this should never happen"))?,
    )?;
    fs::write(marker, [])?;

    Ok(())
}

fn main() -> anyhow::Result<()> {
    let filename = env::var("NIX_ATTRS_JSON_FILE")?;

    let reader = File::open(filename)?;
    let buf_reader = BufReader::new(reader);

    let attrs: StructuredAttrsRoot = serde_json::from_reader(buf_reader)?;

    let mut paths = build_priority_keys(&attrs.paths, 1);
    let mut paths32 = build_priority_keys(&attrs.paths32, 2);

    if attrs.include_closures {
        let refs = build_reference_map(attrs.graph);

        paths = extend_to_closure(paths, &refs)?;
        paths32 = extend_to_closure(paths32, &refs)?;
    }

    let plan = build_plan(paths, paths32)?;

    let out_dir = env::var("out")?;

    build_env(&PathBuf::from(out_dir), plan)
}
