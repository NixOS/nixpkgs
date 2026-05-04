use serde::Deserialize;
use std::collections::{HashMap, HashSet};
use std::fs;
use std::io;
use std::os::unix::fs as unix_fs;
use std::path::{Path, PathBuf};
use std::time::Instant;

/// Config represents the input configuration for unit generation
#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
struct Config {
    #[serde(default)]
    out_dir: String,
    type_dir: String,
    package_source: String,
    upstream_units: Vec<String>,
    upstream_wants: Vec<String>,
    packages: Vec<String>,
    units_dropin: Vec<String>,     // asDropin strategy
    units_autodetect: Vec<String>, // asDropinIfExists strategy
    aliases: HashMap<String, Vec<String>>,
    wanted_by: HashMap<String, Vec<String>>,
    upheld_by: HashMap<String, Vec<String>>,
    required_by: HashMap<String, Vec<String>>,
    allow_collisions: bool,
    is_system_type: bool,
    #[serde(default)]
    default_unit: String,
    #[serde(default)]
    ctrl_alt_del_unit: String,
    lndir_path: String,
    debug: bool,
}

static mut DEBUG: bool = false;

fn log_debug(message: &str) {
    unsafe {
        if DEBUG {
            eprintln!("[DEBUG] {}", message);
        }
    }
}

fn log_timing(phase: &str, start: Instant) {
    unsafe {
        if DEBUG {
            let elapsed = start.elapsed();
            eprintln!("[TIMING] {} took {:?}", phase, elapsed);
        }
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().collect();
    
    let mut config_file = String::new();
    let mut out_dir_override = String::new();
    
    // Parse command line arguments
    let mut i = 1;
    while i < args.len() {
        match args[i].as_str() {
            "-config" => {
                i += 1;
                if i < args.len() {
                    config_file = args[i].clone();
                }
            }
            "-out" => {
                i += 1;
                if i < args.len() {
                    out_dir_override = args[i].clone();
                }
            }
            _ => {}
        }
        i += 1;
    }
    
    if config_file.is_empty() {
        eprintln!("Error: -config flag is required");
        std::process::exit(1);
    }
    
    let data = fs::read_to_string(&config_file)
        .map_err(|e| format!("Error reading config file: {}", e))?;
    
    let mut cfg: Config = serde_json::from_str(&data)
        .map_err(|e| format!("Error parsing config JSON: {}", e))?;
    
    // Override outDir if provided via command line
    if !out_dir_override.is_empty() {
        cfg.out_dir = out_dir_override;
    }
    
    unsafe {
        DEBUG = cfg.debug;
    }
    
    let total_start = Instant::now();
    generate_units(&cfg)?;
    log_timing("Total execution", total_start);
    
    Ok(())
}

fn generate_units(cfg: &Config) -> Result<(), Box<dyn std::error::Error>> {
    // Create output directory
    fs::create_dir_all(&cfg.out_dir)
        .map_err(|e| format!("failed to create output directory: {}", e))?;
    
    // Phase 1: Copy upstream units
    let start = Instant::now();
    copy_upstream_units(cfg)?;
    log_timing("Phase 1: Copy upstream units", start);
    
    // Phase 2: Copy upstream .wants links
    let start = Instant::now();
    copy_upstream_wants(cfg)?;
    log_timing("Phase 2: Copy upstream .wants", start);
    
    // Phase 3: Symlink packages
    let start = Instant::now();
    symlink_packages(cfg)?;
    log_timing("Phase 3: Symlink packages", start);
    
    // Phase 4: Handle units with autodetect strategy
    let start = Instant::now();
    handle_units_autodetect(cfg)?;
    log_timing("Phase 4: Handle autodetect units", start);
    
    // Phase 5: Handle units with dropin strategy
    let start = Instant::now();
    handle_units_dropin(cfg)?;
    log_timing("Phase 5: Handle dropin units", start);
    
    // Phase 6: Create aliases
    let start = Instant::now();
    create_aliases(cfg)?;
    log_timing("Phase 6: Create aliases", start);
    
    // Phase 7: Create .wants/.upholds/.requires
    let start = Instant::now();
    create_dependencies(cfg)?;
    log_timing("Phase 7: Create dependencies", start);
    
    // Phase 8: System-specific symlinks
    if cfg.is_system_type {
        let start = Instant::now();
        create_system_symlinks(cfg)?;
        log_timing("Phase 8: System symlinks", start);
    }
    
    Ok(())
}

// Phase 1: Copy the upstream systemd units we're interested in
fn copy_upstream_units(cfg: &Config) -> Result<(), Box<dyn std::error::Error>> {
    for unit_name in &cfg.upstream_units {
        let fn_path = Path::new(&cfg.package_source)
            .join("example/systemd")
            .join(&cfg.type_dir)
            .join(unit_name);
        
        log_debug(&format!("Processing upstream unit: {}", fn_path.display()));
        
        // Check if file exists
        let metadata = fs::symlink_metadata(&fn_path)
            .map_err(|e| format!("missing {}: {}", fn_path.display(), e))?;
        
        let out_path = Path::new(&cfg.out_dir).join(
            fn_path.file_name().ok_or("invalid file name")?
        );
        
        // Check if output file already exists (handle duplicates in upstream list)
        if fs::symlink_metadata(&out_path).is_ok() {
            log_debug(&format!("Skipping {} - already exists", out_path.display()));
            continue;
        }
        
        if metadata.is_symlink() {
            // It's a symlink
            let target = fs::read_link(&fn_path)
                .map_err(|e| format!("failed to read symlink {}: {}", fn_path.display(), e))?;
            
            // Check if target starts with ../
            let target_str = target.to_str().ok_or("invalid target path")?;
            if target_str.starts_with("../") {
                // Resolve to absolute path and create symlink to that
                let abs_target = fs::canonicalize(&fn_path)
                    .map_err(|e| format!("failed to resolve symlink {}: {}", fn_path.display(), e))?;
                unix_fs::symlink(&abs_target, &out_path)
                    .map_err(|e| format!("failed to create symlink {} -> {}: {}", out_path.display(), abs_target.display(), e))?;
            } else {
                // Copy symlink as-is
                unix_fs::symlink(&target, &out_path)
                    .map_err(|e| format!("failed to copy symlink {}: {}", fn_path.display(), e))?;
            }
        } else {
            // Regular file/directory - create symlink to it
            unix_fs::symlink(&fn_path, &out_path)
                .map_err(|e| format!("failed to symlink {}: {}", fn_path.display(), e))?;
        }
    }
    Ok(())
}

// Phase 2: Copy .wants links
fn copy_upstream_wants(cfg: &Config) -> Result<(), Box<dyn std::error::Error>> {
    for want_name in &cfg.upstream_wants {
        let want_dir = Path::new(&cfg.package_source)
            .join("example/systemd")
            .join(&cfg.type_dir)
            .join(want_name);
        
        log_debug(&format!("Processing upstream want: {}", want_dir.display()));
        
        // Check if directory exists
        fs::metadata(&want_dir)
            .map_err(|e| format!("missing {}: {}", want_dir.display(), e))?;
        
        let out_want_dir = Path::new(&cfg.out_dir).join(
            want_dir.file_name().ok_or("invalid directory name")?
        );
        fs::create_dir(&out_want_dir)
            .map_err(|e| format!("failed to create directory {}: {}", out_want_dir.display(), e))?;
        
        // Iterate over files in the .wants directory
        let entries = fs::read_dir(&want_dir)
            .map_err(|e| format!("failed to read directory {}: {}", want_dir.display(), e))?;
        
        for entry in entries {
            let entry = entry?;
            let src_link_path = entry.path();
            let dst_link_path = out_want_dir.join(entry.file_name());
            
            // Check if it's a symlink
            let metadata = fs::symlink_metadata(&src_link_path)
                .map_err(|e| format!("failed to stat {}: {}", src_link_path.display(), e))?;
            
            if metadata.is_symlink() {
                // It's a symlink - copy it
                let target = fs::read_link(&src_link_path)
                    .map_err(|e| format!("failed to read symlink {}: {}", src_link_path.display(), e))?;
                
                unix_fs::symlink(&target, &dst_link_path)
                    .map_err(|e| format!("failed to copy symlink {}: {}", src_link_path.display(), e))?;
                
                // Check if target exists, if not remove the symlink (prevent dangling unit links)
                if fs::metadata(&dst_link_path).is_err() {
                    let _ = fs::remove_file(&dst_link_path);
                }
            } else {
                // It's a regular file - copy it
                fs::copy(&src_link_path, &dst_link_path)
                    .map_err(|e| format!("failed to copy {}: {}", src_link_path.display(), e))?;
                
                // Preserve permissions
                let permissions = metadata.permissions();
                fs::set_permissions(&dst_link_path, permissions)
                    .map_err(|e| format!("failed to chmod {}: {}", dst_link_path.display(), e))?;
            }
        }
    }
    Ok(())
}

// Phase 3: Symlink all units provided in systemd.packages
fn symlink_packages(cfg: &Config) -> Result<(), Box<dyn std::error::Error>> {
    // Deduplicate packages
    let unique_pkgs: HashSet<_> = cfg.packages.iter().collect();
    
    for pkg in unique_pkgs {
        log_debug(&format!("Processing package: {}", pkg));
        
        // Check both etc/systemd and lib/systemd directories
        let dirs = vec![
            Path::new(pkg).join("etc/systemd").join(&cfg.type_dir),
            Path::new(pkg).join("lib/systemd").join(&cfg.type_dir),
        ];
        
        for dir in dirs {
            let entries = match fs::read_dir(&dir) {
                Ok(e) => e,
                Err(_) => continue, // Directory might not exist, skip
            };
            
            for entry in entries {
                let entry = entry?;
                let fn_path = entry.path();
                let file_name = entry.file_name();
                let file_name_str = file_name.to_string_lossy();
                
                // Skip .wants directories
                if file_name_str.ends_with(".wants") {
                    continue;
                }
                
                let metadata = entry.metadata()?;
                
                if metadata.is_dir() {
                    // Use lndir for directories
                    let target_dir = Path::new(&cfg.out_dir).join(&file_name);
                    fs::create_dir_all(&target_dir)
                        .map_err(|e| format!("failed to create directory {}: {}", target_dir.display(), e))?;
                    lndir(&fn_path, &target_dir)?;
                } else {
                    // Symlink file
                    let out_path = Path::new(&cfg.out_dir).join(&file_name);
                    match unix_fs::symlink(&fn_path, &out_path) {
                        Ok(_) => {},
                        Err(e) if e.kind() == io::ErrorKind::AlreadyExists => {},
                        Err(e) => return Err(format!("failed to symlink {}: {}", fn_path.display(), e).into()),
                    }
                }
            }
        }
    }
    Ok(())
}

// Phase 4: Handle units with asDropinIfExists strategy
fn handle_units_autodetect(cfg: &Config) -> Result<(), Box<dyn std::error::Error>> {
    for unit_path in &cfg.units_autodetect {
        log_debug(&format!("Processing autodetect unit: {}", unit_path));
        
        let entries = fs::read_dir(unit_path)
            .map_err(|e| format!("failed to read unit directory {}: {}", unit_path, e))?;
        
        let entries: Vec<_> = entries.collect::<Result<_, _>>()?;
        if entries.is_empty() {
            continue;
        }
        
        // Warn if multiple files in directory
        if entries.len() > 1 {
            eprintln!(
                "Warning: unit directory {} contains {} files, only processing first: {}",
                unit_path,
                entries.len(),
                entries[0].file_name().to_string_lossy()
            );
        }
        
        let fn_name = entries[0].file_name();
        let out_path = Path::new(&cfg.out_dir).join(&fn_name);
        let unit_file = Path::new(unit_path).join(&fn_name);
        
        // Check if unit already exists in output
        if fs::symlink_metadata(&out_path).is_ok() {
            // Unit exists - check if it's /dev/null
            let target = fs::canonicalize(&unit_file)
                .map_err(|e| format!("failed to resolve {}: {}", unit_file.display(), e))?;
            
            if target == Path::new("/dev/null") {
                // Remove existing and link to /dev/null
                let _ = fs::remove_file(&out_path);
                unix_fs::symlink("/dev/null", &out_path)
                    .map_err(|e| format!("failed to symlink to /dev/null: {}", e))?;
            } else {
                if cfg.allow_collisions {
                    // Create drop-in directory
                    let dropin_dir = Path::new(&cfg.out_dir).join(format!("{}.d", fn_name.to_string_lossy()));
                    fs::create_dir_all(&dropin_dir)
                        .map_err(|e| format!("failed to create dropin dir {}: {}", dropin_dir.display(), e))?;
                    let override_conf = dropin_dir.join("overrides.conf");
                    match unix_fs::symlink(&unit_file, &override_conf) {
                        Ok(_) => {},
                        Err(e) if e.kind() == io::ErrorKind::AlreadyExists => {},
                        Err(e) => return Err(format!("failed to create override: {}", e).into()),
                    }
                } else {
                    return Err(format!("Found multiple derivations configuring {}!", fn_name.to_string_lossy()).into());
                }
            }
        } else {
            // Unit doesn't exist - create symlink
            unix_fs::symlink(&unit_file, &out_path)
                .map_err(|e| format!("failed to symlink unit {}: {}", fn_name.to_string_lossy(), e))?;
        }
    }
    Ok(())
}

// Phase 5: Handle units with asDropin strategy
fn handle_units_dropin(cfg: &Config) -> Result<(), Box<dyn std::error::Error>> {
    for unit_path in &cfg.units_dropin {
        log_debug(&format!("Processing dropin unit: {}", unit_path));
        
        let entries = fs::read_dir(unit_path)
            .map_err(|e| format!("failed to read unit directory {}: {}", unit_path, e))?;
        
        let entries: Vec<_> = entries.collect::<Result<_, _>>()?;
        if entries.is_empty() {
            continue;
        }
        
        // Warn if multiple files in directory
        if entries.len() > 1 {
            eprintln!(
                "Warning: dropin directory {} contains {} files, only processing first: {}",
                unit_path,
                entries.len(),
                entries[0].file_name().to_string_lossy()
            );
        }
        
        let fn_name = entries[0].file_name();
        let unit_file = Path::new(unit_path).join(&fn_name);
        
        // Create drop-in directory
        let dropin_dir = Path::new(&cfg.out_dir).join(format!("{}.d", fn_name.to_string_lossy()));
        fs::create_dir_all(&dropin_dir)
            .map_err(|e| format!("failed to create dropin dir {}: {}", dropin_dir.display(), e))?;
        
        // Create overrides.conf symlink
        let override_conf = dropin_dir.join("overrides.conf");
        match unix_fs::symlink(&unit_file, &override_conf) {
            Ok(_) => {},
            Err(e) if e.kind() == io::ErrorKind::AlreadyExists => {},
            Err(e) => return Err(format!("failed to create override: {}", e).into()),
        }
    }
    Ok(())
}

// Phase 6: Create service aliases
fn create_aliases(cfg: &Config) -> Result<(), Box<dyn std::error::Error>> {
    for (unit_name, aliases) in &cfg.aliases {
        for alias in aliases {
            log_debug(&format!("Creating alias: {} -> {}", alias, unit_name));
            
            let out_path = Path::new(&cfg.out_dir).join(alias);
            // Remove existing symlink if present
            let _ = fs::remove_file(&out_path);
            unix_fs::symlink(unit_name, &out_path)
                .map_err(|e| format!("failed to create alias {} -> {}: {}", alias, unit_name, e))?;
        }
    }
    Ok(())
}

// Phase 7: Create .wants/.upholds/.requires symlinks
fn create_dependencies(cfg: &Config) -> Result<(), Box<dyn std::error::Error>> {
    // Handle .wants
    for (unit_name, targets) in &cfg.wanted_by {
        for target in targets {
            log_debug(&format!("Creating .wants: {}.wants/{}", target, unit_name));
            
            let wants_dir = Path::new(&cfg.out_dir).join(format!("{}.wants", target));
            fs::create_dir_all(&wants_dir)
                .map_err(|e| format!("failed to create .wants dir: {}", e))?;
            
            let link_path = wants_dir.join(unit_name);
            let link_target = format!("../{}", unit_name);
            let _ = fs::remove_file(&link_path);
            unix_fs::symlink(&link_target, &link_path)
                .map_err(|e| format!("failed to create .wants symlink: {}", e))?;
        }
    }
    
    // Handle .upholds
    for (unit_name, targets) in &cfg.upheld_by {
        for target in targets {
            log_debug(&format!("Creating .upholds: {}.upholds/{}", target, unit_name));
            
            let upholds_dir = Path::new(&cfg.out_dir).join(format!("{}.upholds", target));
            fs::create_dir_all(&upholds_dir)
                .map_err(|e| format!("failed to create .upholds dir: {}", e))?;
            
            let link_path = upholds_dir.join(unit_name);
            let link_target = format!("../{}", unit_name);
            let _ = fs::remove_file(&link_path);
            unix_fs::symlink(&link_target, &link_path)
                .map_err(|e| format!("failed to create .upholds symlink: {}", e))?;
        }
    }
    
    // Handle .requires
    for (unit_name, targets) in &cfg.required_by {
        for target in targets {
            log_debug(&format!("Creating .requires: {}.requires/{}", target, unit_name));
            
            let requires_dir = Path::new(&cfg.out_dir).join(format!("{}.requires", target));
            fs::create_dir_all(&requires_dir)
                .map_err(|e| format!("failed to create .requires dir: {}", e))?;
            
            let link_path = requires_dir.join(unit_name);
            let link_target = format!("../{}", unit_name);
            let _ = fs::remove_file(&link_path);
            unix_fs::symlink(&link_target, &link_path)
                .map_err(|e| format!("failed to create .requires symlink: {}", e))?;
        }
    }
    
    Ok(())
}

// Phase 8: Create system-specific symlinks
fn create_system_symlinks(cfg: &Config) -> Result<(), Box<dyn std::error::Error>> {
    if !cfg.default_unit.is_empty() {
        log_debug(&format!("Creating default.target -> {}", cfg.default_unit));
        let out_path = Path::new(&cfg.out_dir).join("default.target");
        unix_fs::symlink(&cfg.default_unit, &out_path)
            .map_err(|e| format!("failed to create default.target: {}", e))?;
    }
    
    if !cfg.ctrl_alt_del_unit.is_empty() {
        log_debug(&format!("Creating ctrl-alt-del.target -> {}", cfg.ctrl_alt_del_unit));
        let out_path = Path::new(&cfg.out_dir).join("ctrl-alt-del.target");
        unix_fs::symlink(&cfg.ctrl_alt_del_unit, &out_path)
            .map_err(|e| format!("failed to create ctrl-alt-del.target: {}", e))?;
    }
    
    // Create multi-user.target.wants/remote-fs.target
    let wants_dir = Path::new(&cfg.out_dir).join("multi-user.target.wants");
    fs::create_dir_all(&wants_dir)
        .map_err(|e| format!("failed to create multi-user.target.wants: {}", e))?;
    let link_path = wants_dir.join("remote-fs.target");
    unix_fs::symlink("../remote-fs.target", &link_path)
        .map_err(|e| format!("failed to create remote-fs.target link: {}", e))?;
    
    Ok(())
}

// lndir implements the xorg lndir functionality natively
// Recursively creates directories, and symlinks files from src to dst
fn lndir(src: &Path, dst: &Path) -> Result<(), Box<dyn std::error::Error>> {
    for entry in walkdir::WalkDir::new(src) {
        let entry = entry?;
        let path = entry.path();
        
        // Skip the root directory itself
        if path == src {
            continue;
        }
        
        let rel_path = path.strip_prefix(src)?;
        let dst_path = dst.join(rel_path);
        
        if entry.file_type().is_dir() {
            fs::create_dir_all(&dst_path)?;
        } else {
            // Create symlink to the source file
            unix_fs::symlink(path, &dst_path)?;
        }
    }
    Ok(())
}
