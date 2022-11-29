use std::os::unix::ffi::OsStringExt;
use std::ffi::{OsStr,OsString};
use std::path::{Path,PathBuf};

use std::env;
use std::fs;
use std::fs::{OpenOptions};
use std::process::{Command,exit};
use std::io::Write;
use std::io;

use std::collections::HashSet;
use std::collections::VecDeque;
use std::hash::Hash;

fn main() {
    let args : Vec<OsString> = env::args_os().collect();
    let allow_missing = env::var_os("allowMissing").is_some();
    let firmware_dir = env::var_os("firmware").unwrap();
    let out_dir = env::var_os("out").unwrap();
    let kernel_dir = env::var_os("kernel").unwrap();
    let version = env::var_os("version").unwrap();

    let kernel_dir = Path::new(&kernel_dir).to_path_buf();
    let out_dir = Path::new(&out_dir).to_path_buf();
    let firmware_dir = Path::new(&firmware_dir).to_path_buf();
    let kernel = KernelData { path : kernel_dir, version : version };

    // resolve the root modules
    let roots = (args[1..]).iter().cloned().flat_map(|root| {
        if let Some(mods) = mod_resolve(&kernel,allow_missing,&root) {
            for module in &mods {
                println!("resolved root module {} to {}",
                        &root.to_string_lossy(),
                        &module.to_string_lossy());
            }
            mods
        } else {
            Vec::new()
        }
    }).collect();

    let cl = closure(|module| mod_resolved_deps(&kernel,allow_missing,&module), &roots);
    let mut insmod_list = OpenOptions::new()
        .append(true)
        .create(true)
        .open(out_dir.join("insmod-list"))
        .unwrap();

    for module in cl {
        for source in mod_paths(&kernel,allow_missing,&module).iter()
            .filter_map(|modpath| match modpath { ModPath::Path(path) => Some(path), _ => None }) {
            let target = out_dir.join(
                source.strip_prefix(&kernel.path).unwrap()
            );
            copy_mod(&source,&target);
            // If the kernel is compiled with coverage instrumentation, it
            // contains the paths of the *.gcda coverage data output files
            // (which it doesn't actually use...).  Get rid of them to prevent
            // the whole kernel from being included in the initrd.
            nuke_refs(&target);
            writeln!(insmod_list,"{}",target.display());
        }
        copy_firmware(&kernel,allow_missing,&firmware_dir,&out_dir,&module);
    }
}

pub struct KernelData {
    path : PathBuf,
    version : OsString,
}

pub enum ModPath {
    Path(PathBuf),
    Builtin
}

fn mod_missing(kernel : &KernelData,
               allow_missing : bool,
               module : &OsString) {
    eprintln!("modinfo failed!");
    eprintln!("that likely means that the module: {}",
              &module.to_string_lossy() );
    eprintln!("was not found in: {}", &kernel.path.display());
    if !allow_missing {
        exit(1)
    }
}

// Call modinfo on the given data and return the lines of its output.
fn modinfo<P : AsRef<OsStr>>(kernel : &KernelData,
                             allow_missing : bool,
                             module : &OsString,
                             field : P)
    -> Option<Vec<Vec<u8>>> {
    let out = Command::new("modinfo")
        .arg("-b").arg(&kernel.path)
        .arg("-k").arg(&kernel.version)
        .arg("-F").arg(field)
        .arg(module)
        .output()
        .expect("failed to execute modinfo");
    if out.status.success() {
        Some(
            out.stdout
            .split(|c| *c == b'\n')
            .map(|sl| Vec::from(sl))
            .filter(|v| !v.is_empty())
            .collect()
            )
    } else {
        mod_missing(&kernel,allow_missing,&module);
        None
    }
}


fn mod_paths(kernel : &KernelData,
            allow_missing : bool,
            module : &OsString)
    -> Vec<ModPath> {

    if let Some(fnames) = modinfo(&kernel,allow_missing,module,"filename") {
        fnames.iter().cloned().map(OsString::from_vec).map(|fname| {
            if fname == OsString::from("(builtin)") {
                ModPath::Builtin
            } else {
                let path = Path::new(&fname);
                ModPath::Path(path.to_path_buf())
            }
        }).collect()
    } else {
        Vec::new()
    }
}

fn copy_mod(source : &Path, target : &Path) {
    let target_dir = target.parent().unwrap();
    fs::create_dir_all(&target_dir).unwrap();
    copy_with_trace("module",&source,&target).unwrap();
}

fn copy_firmware(kernel : &KernelData,
                 allow_missing : bool,
                 firmware_dir : &Path,
                 out_dir : &Path,
                 module : &OsString) {
    if let Some(out) = modinfo(&kernel,allow_missing,&module,"firmware") {
        let firmware : Vec<OsString> = out
            .into_iter()
            .map(OsString::from_vec)
            .collect();
        for fw in firmware {
            let [source,source_xz] = firmware_files(&fw,&firmware_dir);
            let [target,target_xz] = firmware_files(&fw,&out_dir);

            if let Some(root) = target.parent() {
                fs::create_dir_all(&root).unwrap();
            }

            let res = if source_xz.try_exists().unwrap() {
                copy_with_trace("firmware",&source_xz,&target_xz)
            } else if source.try_exists().unwrap() {
                copy_with_trace("firmware",&source,&target)
            } else {
              eprintln!("WARNING: missing firmware {} for module {}",
                &fw.to_string_lossy(),
                &module.to_string_lossy()
                );
              Ok(())
            };
            if let Err(err) = res {
                panic!("{}",err)
            }
        }
    }
}

fn copy_with_trace(name : &str, source : &Path, target : &Path) -> io::Result<()> {
    println!("  copying {} {}\nto {}",
      &name,
      &source.display(),
      &target.display());
    fs::copy(&source,&target).map(|_| ())
}

fn firmware_files(fw : &OsString, dir : &Path) -> [PathBuf;2] {
  let mut fw_xz = fw.clone();
  fw_xz.push(".xz");
  [ fw.clone(), fw_xz ].map(|s| dir.join("lib/firmware").join(s))
}

fn mod_resolve(kernel : &KernelData,
               allow_missing : bool,
               module : &OsString) -> Option<Vec<OsString>> {
    let names = modinfo(&kernel,allow_missing,&module,"name")?;
    Some(
        names
        .into_iter()
        .map(OsString::from_vec)
        .collect()
    )
}


fn mod_deps(kernel : &KernelData,
            allow_missing : bool,
            module : &OsString) -> Vec<OsString> {
    let dep_lists = modinfo(&kernel,allow_missing,module,"depends")
        .unwrap();
    dep_lists
        .into_iter()
        .flat_map(|deps|
            deps
            .split(|c| *c == b',')
            .map(to_os)
            .collect::<Vec<OsString>>()
            )
        .collect()
}

fn mod_soft_deps(kernel : &KernelData,
                 allow_missing : bool,
                 module : &OsString) -> Vec<OsString> {
    let dep_lists = modinfo(&kernel,allow_missing,module,"softdep")
        .unwrap();
    dep_lists.into_iter()
        .flat_map(parse_soft_deps)
        .collect()
}

fn parse_soft_deps(line : Vec<u8>) -> Vec<OsString> {
    line.split(|c| c.is_ascii_whitespace())
        .map(to_os)
        .filter( |s| !s.is_empty()
                && !(*s == OsString::from("pre:"))
                && !(*s == OsString::from("post:")) )
        .collect()
}

fn mod_resolved_deps(kernel : &KernelData,
                     allow_missing : bool,
                     module : &OsString) -> HashSet<OsString> {
    let deps = mod_deps(&kernel,allow_missing,&module);
    let soft_deps = mod_soft_deps(&kernel,allow_missing,&module);
    deps.into_iter()
        .chain(soft_deps.into_iter())
                .flat_map(|dep|
            mod_resolve(&kernel,allow_missing,&dep)
            .unwrap_or_else(|| Vec::new())
            )
        .collect()
}

fn nuke_refs(path : &Path){
    println!("nuking references on {}", &path.display());
    let out = Command::new("nuke-refs")
        .arg(&path)
        .output()
        .expect("failed to execute nuke-refs");
    if ! out.status.success() {
        eprintln!("nuke-refs failed on {}",path.display())
    }
}


// Traverse dependency tree in DFS fashion, returns the closure in form of a HashSet.
fn closure<F : Fn(&T) -> HashSet<T>,T : Hash + Eq + Clone>(
    f : F,
    start : &HashSet<T>
    )
    -> HashSet<T> {

    let mut visited = HashSet::new();
    let mut todo : VecDeque::<T> = start.iter().cloned().collect();
    while let Some(p) = todo.pop_front() {
        let deps : HashSet<T> = f(&p);
        visited.insert(p);
        for dep in deps {
            if !visited.contains(&dep) {
                todo.push_back(dep);
            }
        }
    }
    return visited;
}

fn to_os(bs : &[u8]) -> OsString {
    OsString::from_vec(bs.to_vec())
}
