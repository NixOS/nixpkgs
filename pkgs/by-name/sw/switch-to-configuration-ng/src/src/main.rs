#![deny(clippy::all)]
#![allow(clippy::too_many_arguments)]
#![allow(clippy::type_complexity)]

use std::{
    cell::RefCell,
    collections::HashMap,
    io::{BufRead, Read, Write},
    os::unix::{fs::PermissionsExt, process::CommandExt},
    path::{Path, PathBuf},
    rc::Rc,
    str::FromStr,
    sync::OnceLock,
    time::Duration,
};

use anyhow::{anyhow, bail, Context, Result};
use dbus::{
    blocking::{stdintf::org_freedesktop_dbus::Properties, LocalConnection, Proxy},
    Message,
};
use glob::glob;
use ini::{Ini, ParseOption};
use log::LevelFilter;
use nix::{
    fcntl::{Flock, FlockArg, OFlag},
    sys::{
        signal::{self, SigHandler, Signal},
        stat::Mode,
    },
};
use regex::Regex;
use syslog::Facility;

mod systemd_manager {
    #![allow(non_upper_case_globals)]
    #![allow(non_camel_case_types)]
    #![allow(non_snake_case)]
    #![allow(unused)]
    #![allow(clippy::all)]
    include!(concat!(env!("OUT_DIR"), "/systemd_manager.rs"));
}

mod logind_manager {
    #![allow(non_upper_case_globals)]
    #![allow(non_camel_case_types)]
    #![allow(non_snake_case)]
    #![allow(unused)]
    #![allow(clippy::all)]
    include!(concat!(env!("OUT_DIR"), "/logind_manager.rs"));
}

use crate::systemd_manager::OrgFreedesktopSystemd1Manager;
use crate::{
    logind_manager::OrgFreedesktopLogin1Manager,
    systemd_manager::{
        OrgFreedesktopSystemd1ManagerJobRemoved, OrgFreedesktopSystemd1ManagerReloading,
    },
};

type UnitInfo = HashMap<String, HashMap<String, Vec<String>>>;

const SYSINIT_REACTIVATION_TARGET: &str = "sysinit-reactivation.target";

// To be robust against interruption, record what units need to be started etc. We read these files
// again every time this program starts to make sure we continue where the old (interrupted) script
// left off.
const START_LIST_FILE: &str = "/run/nixos/start-list";
const RESTART_LIST_FILE: &str = "/run/nixos/restart-list";
const RELOAD_LIST_FILE: &str = "/run/nixos/reload-list";

// Parse restart/reload requests by the activation script. Activation scripts may write
// newline-separated units to the restart file and switch-to-configuration will handle them. While
// `stopIfChanged = true` is ignored, switch-to-configuration will handle `restartIfChanged =
// false` and `reloadIfChanged = true`. This is the same as specifying a restart trigger in the
// NixOS module.
//
// The reload file asks this program to reload a unit. This is the same as specifying a reload
// trigger in the NixOS module and can be ignored if the unit is restarted in this activation.
const RESTART_BY_ACTIVATION_LIST_FILE: &str = "/run/nixos/activation-restart-list";
const RELOAD_BY_ACTIVATION_LIST_FILE: &str = "/run/nixos/activation-reload-list";
const DRY_RESTART_BY_ACTIVATION_LIST_FILE: &str = "/run/nixos/dry-activation-restart-list";
const DRY_RELOAD_BY_ACTIVATION_LIST_FILE: &str = "/run/nixos/dry-activation-reload-list";

#[derive(Debug, Clone, PartialEq)]
enum Action {
    Switch,
    Check,
    Boot,
    Test,
    DryActivate,
}

impl std::str::FromStr for Action {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> std::result::Result<Self, Self::Err> {
        Ok(match s {
            "switch" => Self::Switch,
            "boot" => Self::Boot,
            "test" => Self::Test,
            "dry-activate" => Self::DryActivate,
            "check" => Self::Check,
            _ => bail!("invalid action {s}"),
        })
    }
}

impl From<&Action> for &'static str {
    fn from(val: &Action) -> Self {
        match val {
            Action::Switch => "switch",
            Action::Boot => "boot",
            Action::Test => "test",
            Action::DryActivate => "dry-activate",
            Action::Check => "check",
        }
    }
}

// Allow for this switch-to-configuration to remain consistent with the perl implementation.
// Perl's "die" uses errno to set the exit code: https://perldoc.perl.org/perlvar#%24%21
fn die() -> ! {
    std::process::exit(std::io::Error::last_os_error().raw_os_error().unwrap_or(1));
}

fn parse_os_release() -> Result<HashMap<String, String>> {
    Ok(std::fs::read_to_string("/etc/os-release")
        .context("Failed to read /etc/os-release")?
        .lines()
        .fold(HashMap::new(), |mut acc, line| {
            if let Some((k, v)) = line.split_once('=') {
                acc.insert(k.to_string(), v.to_string());
            }

            acc
        }))
}

fn do_pre_switch_check(command: &str, toplevel: &Path) -> Result<()> {
    let mut cmd_split = command.split_whitespace();
    let Some(argv0) = cmd_split.next() else {
        bail!("missing first argument in install bootloader commands");
    };

    match std::process::Command::new(argv0)
        .args(cmd_split.collect::<Vec<&str>>())
        .arg(toplevel)
        .spawn()
        .map(|mut child| child.wait())
    {
        Ok(Ok(status)) if status.success() => {}
        _ => {
            eprintln!("Pre-switch checks failed");
            die()
        }
    }

    Ok(())
}

fn do_install_bootloader(command: &str, toplevel: &Path) -> Result<()> {
    let mut cmd_split = command.split_whitespace();
    let Some(argv0) = cmd_split.next() else {
        bail!("missing first argument in install bootloader commands");
    };

    match std::process::Command::new(argv0)
        .args(cmd_split.collect::<Vec<&str>>())
        .arg(toplevel)
        .spawn()
        .map(|mut child| child.wait())
    {
        Ok(Ok(status)) if status.success() => {}
        _ => {
            eprintln!("Failed to install bootloader");
            die();
        }
    }

    Ok(())
}

extern "C" fn handle_sigpipe(_signal: nix::libc::c_int) {}

fn required_env(var: &str) -> anyhow::Result<String> {
    std::env::var(var).with_context(|| format!("missing required environment variable ${var}"))
}

#[derive(Debug)]
struct UnitState {
    state: String,
    substate: String,
}

// Asks the currently running systemd instance via dbus which units are active. Returns a hash
// where the key is the name of each unit and the value a hash of load, state, substate.
fn get_active_units(
    systemd_manager: &Proxy<'_, &LocalConnection>,
) -> Result<HashMap<String, UnitState>> {
    let units = systemd_manager
        .list_units_by_patterns(Vec::new(), Vec::new())
        .context("Failed to list systemd units")?;

    Ok(units
        .into_iter()
        .filter_map(
            |(
                id,
                _description,
                _load_state,
                active_state,
                sub_state,
                following,
                _unit_path,
                _job_id,
                _job_type,
                _job_path,
            )| {
                if following.is_empty() && active_state != "inactive" {
                    Some((id, active_state, sub_state))
                } else {
                    None
                }
            },
        )
        .fold(HashMap::new(), |mut acc, (id, active_state, sub_state)| {
            acc.insert(
                id,
                UnitState {
                    state: active_state,
                    substate: sub_state,
                },
            );

            acc
        }))
}

// This function takes a single ini file that specified systemd configuration like unit
// configuration and parses it into a HashMap where the keys are the sections of the unit file and
// the values are HashMaps themselves. These HashMaps have the unit file keys as their keys (left
// side of =) and an array of all values that were set as their values. If a value is empty (for
// example `ExecStart=`), then all current definitions are removed.
//
// Instead of returning the HashMap, this function takes a mutable reference to a HashMap to return
// the data in. This allows calling the function multiple times with the same Hashmap to parse
// override files.
fn parse_systemd_ini(data: &mut UnitInfo, mut unit_file: impl Read) -> Result<()> {
    let mut unit_file_content = String::new();
    _ = unit_file
        .read_to_string(&mut unit_file_content)
        .context("Failed to read unit file")?;

    let ini = Ini::load_from_str_opt(
        &unit_file_content,
        ParseOption {
            enabled_quote: true,
            // Allow for escaped characters that won't get interpreted by the INI parser. These
            // often show up in systemd unit files device/mount/swap unit names (e.g. dev-disk-by\x2dlabel-root.device).
            enabled_escape: false,
        },
    )
    .context("Failed parse unit file as INI")?;

    // Copy over all sections
    for (section, properties) in ini.iter() {
        let Some(section) = section else {
            continue;
        };

        if section == "Install" {
            // Skip the [Install] section because it has no relevant keys for us
            continue;
        }

        let section_map = if let Some(section_map) = data.get_mut(section) {
            section_map
        } else {
            data.insert(section.to_string(), HashMap::new());
            data.get_mut(section)
                .ok_or(anyhow!("section name should exist in hashmap"))?
        };

        for (ini_key, _) in properties {
            let values = properties.get_all(ini_key);
            let values = values
                .into_iter()
                .map(String::from)
                .collect::<Vec<String>>();

            // Go over all values
            let mut new_vals = Vec::new();
            let mut clear_existing = false;

            for val in values {
                // If a value is empty, it's an override that tells us to clean the value
                if val.is_empty() {
                    new_vals.clear();
                    clear_existing = true;
                } else {
                    new_vals.push(val);
                }
            }

            match (section_map.get_mut(ini_key), clear_existing) {
                (Some(existing_vals), false) => existing_vals.extend(new_vals),
                _ => _ = section_map.insert(ini_key.to_string(), new_vals),
            };
        }
    }

    Ok(())
}

// This function takes the path to a systemd configuration file (like a unit configuration) and
// parses it into a UnitInfo structure.
//
// If a directory with the same basename ending in .d exists next to the unit file, it will be
// assumed to contain override files which will be parsed as well and handled properly.
fn parse_unit(unit_file: &Path, base_unit_path: &Path) -> Result<UnitInfo> {
    // Parse the main unit and all overrides
    let mut unit_data = HashMap::new();

    let base_unit_file = std::fs::File::open(base_unit_path)
        .with_context(|| format!("Failed to open unit file {}", base_unit_path.display()))?;
    parse_systemd_ini(&mut unit_data, base_unit_file).with_context(|| {
        format!(
            "Failed to parse systemd unit file {}",
            base_unit_path.display()
        )
    })?;

    for entry in
        glob(&format!("{}.d/*.conf", base_unit_path.display())).context("Invalid glob pattern")?
    {
        let Ok(entry) = entry else {
            continue;
        };

        let unit_file = std::fs::File::open(&entry)
            .with_context(|| format!("Failed to open unit file {}", entry.display()))?;
        parse_systemd_ini(&mut unit_data, unit_file)?;
    }

    // Handle drop-in template-unit instance overrides
    if unit_file != base_unit_path {
        for entry in
            glob(&format!("{}.d/*.conf", unit_file.display())).context("Invalid glob pattern")?
        {
            let Ok(entry) = entry else {
                continue;
            };

            let unit_file = std::fs::File::open(&entry)
                .with_context(|| format!("Failed to open unit file {}", entry.display()))?;
            parse_systemd_ini(&mut unit_data, unit_file)?;
        }
    }

    Ok(unit_data)
}

// Checks whether a specified boolean in a systemd unit is true or false, with a default that is
// applied when the value is not set.
fn parse_systemd_bool(
    unit_data: Option<&UnitInfo>,
    section_name: &str,
    bool_name: &str,
    default: bool,
) -> bool {
    if let Some(Some(Some(Some(b)))) = unit_data.map(|data| {
        data.get(section_name).map(|section| {
            section.get(bool_name).map(|vals| {
                vals.last()
                    .map(|last| matches!(last.as_str(), "1" | "yes" | "true" | "on"))
            })
        })
    }) {
        b
    } else {
        default
    }
}

#[derive(Debug, PartialEq)]
enum UnitComparison {
    Equal,
    UnequalNeedsRestart,
    UnequalNeedsReload,
}

// Compare the contents of two unit files and return whether the unit needs to be restarted or
// reloaded. If the units differ, the service is restarted unless the only difference is
// `X-Reload-Triggers` in the `Unit` section. If this is the only modification, the unit is
// reloaded instead of restarted. If the only difference is `Options` in the `[Mount]` section, the
// unit is reloaded rather than restarted.
fn compare_units(current_unit: &UnitInfo, new_unit: &UnitInfo) -> UnitComparison {
    let mut ret = UnitComparison::Equal;

    let unit_section_ignores = HashMap::from(
        [
            "X-Reload-Triggers",
            "Description",
            "Documentation",
            "OnFailure",
            "OnSuccess",
            "OnFailureJobMode",
            "IgnoreOnIsolate",
            "StopWhenUnneeded",
            "RefuseManualStart",
            "RefuseManualStop",
            "AllowIsolate",
            "CollectMode",
            "SourcePath",
        ]
        .map(|name| (name, ())),
    );

    let mut section_cmp = new_unit.keys().fold(HashMap::new(), |mut acc, key| {
        acc.insert(key.as_str(), ());
        acc
    });

    // Iterate over the sections
    for (section_name, section_val) in current_unit {
        // Missing section in the new unit?
        if !section_cmp.contains_key(section_name.as_str()) {
            // If the [Unit] section was removed, make sure that only keys were in it that are
            // ignored
            if section_name == "Unit" {
                for ini_key in section_val.keys() {
                    if !unit_section_ignores.contains_key(ini_key.as_str()) {
                        return UnitComparison::UnequalNeedsRestart;
                    }
                }
                continue; // check the next section
            } else {
                return UnitComparison::UnequalNeedsRestart;
            }
        }

        section_cmp.remove(section_name.as_str());

        // Comparison hash for the section contents
        let mut ini_cmp = new_unit
            .get(section_name)
            .map(|section_val| {
                section_val.keys().fold(HashMap::new(), |mut acc, ini_key| {
                    acc.insert(ini_key.as_str(), ());
                    acc
                })
            })
            .unwrap_or_default();

        // Iterate over the keys of the section
        for (ini_key, current_value) in section_val {
            ini_cmp.remove(ini_key.as_str());
            let Some(Some(new_value)) = new_unit
                .get(section_name)
                .map(|section| section.get(ini_key))
            else {
                // If the key is missing in the new unit, they are different unless the key that is
                // now missing is one of the ignored keys
                if section_name == "Unit" && unit_section_ignores.contains_key(ini_key.as_str()) {
                    continue;
                }
                return UnitComparison::UnequalNeedsRestart;
            };

            // If the contents are different, the units are different
            if current_value != new_value {
                if section_name == "Unit" {
                    if ini_key == "X-Reload-Triggers" {
                        ret = UnitComparison::UnequalNeedsReload;
                        continue;
                    } else if unit_section_ignores.contains_key(ini_key.as_str()) {
                        continue;
                    }
                }

                // If this is a mount unit, check if it was only `Options`
                if section_name == "Mount" && ini_key == "Options" {
                    ret = UnitComparison::UnequalNeedsReload;
                    continue;
                }

                return UnitComparison::UnequalNeedsRestart;
            }
        }

        // A key was introduced that was missing in the previous unit
        if !ini_cmp.is_empty() {
            if section_name == "Unit" {
                for (ini_key, _) in ini_cmp {
                    if ini_key == "X-Reload-Triggers" {
                        ret = UnitComparison::UnequalNeedsReload;
                    } else if unit_section_ignores.contains_key(ini_key) {
                        continue;
                    } else {
                        return UnitComparison::UnequalNeedsRestart;
                    }
                }
            } else {
                return UnitComparison::UnequalNeedsRestart;
            }
        }
    }

    // A section was introduced that was missing in the previous unit
    if !section_cmp.is_empty() {
        if section_cmp.keys().len() == 1 && section_cmp.contains_key("Unit") {
            if let Some(new_unit_unit) = new_unit.get("Unit") {
                for ini_key in new_unit_unit.keys() {
                    if !unit_section_ignores.contains_key(ini_key.as_str()) {
                        return UnitComparison::UnequalNeedsRestart;
                    } else if ini_key == "X-Reload-Triggers" {
                        ret = UnitComparison::UnequalNeedsReload;
                    }
                }
            }
        } else {
            return UnitComparison::UnequalNeedsRestart;
        }
    }

    ret
}

// Called when a unit exists in both the old systemd and the new system and the units differ. This
// figures out of what units are to be stopped, restarted, reloaded, started, and skipped.
fn handle_modified_unit(
    toplevel: &Path,
    unit: &str,
    base_name: &str,
    new_unit_file: &Path,
    new_base_unit_file: &Path,
    new_unit_info: Option<&UnitInfo>,
    active_cur: &HashMap<String, UnitState>,
    units_to_stop: &mut HashMap<String, ()>,
    units_to_start: &mut HashMap<String, ()>,
    units_to_reload: &mut HashMap<String, ()>,
    units_to_restart: &mut HashMap<String, ()>,
    units_to_skip: &mut HashMap<String, ()>,
) -> Result<()> {
    let use_restart_as_stop_and_start = new_unit_info.is_none();

    if matches!(
        unit,
        "sysinit.target" | "basic.target" | "multi-user.target" | "graphical.target"
    ) || unit.ends_with(".unit")
        || unit.ends_with(".slice")
    {
        // Do nothing.  These cannot be restarted directly.

        // Slices and Paths don't have to be restarted since properties (resource limits and
        // inotify watches) seem to get applied on daemon-reload.
    } else if unit.ends_with(".mount") {
        // Just restart the unit. We wouldn't have gotten into this subroutine if only `Options`
        // was changed, in which case the unit would be reloaded. The only exception is / and /nix
        // because it's very unlikely we can safely unmount them so we reload them instead. This
        // means that we may not get all changes into the running system but it's better than
        // crashing it.
        if unit == "-.mount" || unit == "nix.mount" {
            units_to_reload.insert(unit.to_string(), ());
            record_unit(RELOAD_LIST_FILE, unit);
        } else {
            units_to_restart.insert(unit.to_string(), ());
            record_unit(RESTART_LIST_FILE, unit);
        }
    } else if unit.ends_with(".socket") {
        // FIXME: do something?
        // Attempt to fix this: https://github.com/NixOS/nixpkgs/pull/141192
        // Revert of the attempt: https://github.com/NixOS/nixpkgs/pull/147609
        // More details: https://github.com/NixOS/nixpkgs/issues/74899#issuecomment-981142430
    } else {
        let fallback = parse_unit(new_unit_file, new_base_unit_file)?;
        let new_unit_info = if new_unit_info.is_some() {
            new_unit_info
        } else {
            Some(&fallback)
        };

        if parse_systemd_bool(new_unit_info, "Service", "X-ReloadIfChanged", false)
            && !units_to_restart.contains_key(unit)
            && !(if use_restart_as_stop_and_start {
                units_to_restart.contains_key(unit)
            } else {
                units_to_stop.contains_key(unit)
            })
        {
            units_to_reload.insert(unit.to_string(), ());
            record_unit(RELOAD_LIST_FILE, unit);
        } else if !parse_systemd_bool(new_unit_info, "Service", "X-RestartIfChanged", true)
            || parse_systemd_bool(new_unit_info, "Unit", "RefuseManualStop", false)
            || parse_systemd_bool(new_unit_info, "Unit", "X-OnlyManualStart", false)
        {
            units_to_skip.insert(unit.to_string(), ());
        } else {
            // It doesn't make sense to stop and start non-services because they can't have
            // ExecStop=
            if !parse_systemd_bool(new_unit_info, "Service", "X-StopIfChanged", true)
                || !unit.ends_with(".service")
            {
                // This unit should be restarted instead of stopped and started.
                units_to_restart.insert(unit.to_string(), ());
                record_unit(RESTART_LIST_FILE, unit);
                // Remove from units to reload so we don't restart and reload
                if units_to_reload.contains_key(unit) {
                    units_to_reload.remove(unit);
                    unrecord_unit(RELOAD_LIST_FILE, unit);
                }
            } else {
                // If this unit is socket-activated, then stop the socket unit(s) as well, and
                // restart the socket(s) instead of the service.
                let mut socket_activated = false;
                if unit.ends_with(".service") {
                    let mut sockets = if let Some(Some(Some(sockets))) = new_unit_info.map(|info| {
                        info.get("Service")
                            .map(|service_section| service_section.get("Sockets"))
                    }) {
                        sockets
                            .join(" ")
                            .split_whitespace()
                            .map(String::from)
                            .collect()
                    } else {
                        Vec::new()
                    };

                    if sockets.is_empty() {
                        sockets.push(format!("{}.socket", base_name));
                    }

                    for socket in &sockets {
                        if active_cur.contains_key(socket) {
                            // We can now be sure this is a socket-activated unit

                            if use_restart_as_stop_and_start {
                                units_to_restart.insert(socket.to_string(), ());
                            } else {
                                units_to_stop.insert(socket.to_string(), ());
                            }

                            // Only restart sockets that actually exist in new configuration:
                            if toplevel.join("etc/systemd/system").join(socket).exists() {
                                if use_restart_as_stop_and_start {
                                    units_to_restart.insert(socket.to_string(), ());
                                    record_unit(RESTART_LIST_FILE, socket);
                                } else {
                                    units_to_start.insert(socket.to_string(), ());
                                    record_unit(START_LIST_FILE, socket);
                                }

                                socket_activated = true;
                            }

                            // Remove from units to reload so we don't restart and reload
                            if units_to_reload.contains_key(unit) {
                                units_to_reload.remove(unit);
                                unrecord_unit(RELOAD_LIST_FILE, unit);
                            }
                        }
                    }
                }

                // If the unit is not socket-activated, record that this unit needs to be started
                // below. We write this to a file to ensure that the service gets restarted if
                // we're interrupted.
                if !socket_activated {
                    if use_restart_as_stop_and_start {
                        units_to_restart.insert(unit.to_string(), ());
                        record_unit(RESTART_LIST_FILE, unit);
                    } else {
                        units_to_start.insert(unit.to_string(), ());
                        record_unit(START_LIST_FILE, unit);
                    }
                }

                if use_restart_as_stop_and_start {
                    units_to_restart.insert(unit.to_string(), ());
                } else {
                    units_to_stop.insert(unit.to_string(), ());
                }
                // Remove from units to reload so we don't restart and reload
                if units_to_reload.contains_key(unit) {
                    units_to_reload.remove(unit);
                    unrecord_unit(RELOAD_LIST_FILE, unit);
                }
            }
        }
    }

    Ok(())
}

// Writes a unit name into a given file to be more resilient against crashes of the script. Does
// nothing when the action is dry-activate.
fn record_unit(p: impl AsRef<Path>, unit: &str) {
    if ACTION.get() != Some(&Action::DryActivate) {
        if let Ok(mut f) = std::fs::File::options().append(true).create(true).open(p) {
            _ = writeln!(&mut f, "{unit}");
        }
    }
}

// The opposite of record_unit, removes a unit name from a file
fn unrecord_unit(p: impl AsRef<Path>, unit: &str) {
    if ACTION.get() != Some(&Action::DryActivate) {
        if let Ok(contents) = std::fs::read_to_string(&p) {
            if let Ok(mut f) = std::fs::File::options()
                .write(true)
                .truncate(true)
                .create(true)
                .open(&p)
            {
                contents
                    .lines()
                    .filter(|line| line != &unit)
                    .for_each(|line| _ = writeln!(&mut f, "{line}"))
            }
        }
    }
}

fn map_from_list_file(p: impl AsRef<Path>) -> HashMap<String, ()> {
    std::fs::read_to_string(p)
        .unwrap_or_default()
        .lines()
        .filter(|line| !line.is_empty())
        .fold(HashMap::new(), |mut acc, line| {
            acc.insert(line.to_string(), ());
            acc
        })
}

#[derive(Debug)]
struct Filesystem {
    device: String,
    fs_type: String,
    options: String,
}

#[derive(Debug)]
#[allow(unused)]
struct Swap(String);

// Parse a fstab file, given its path. Returns a tuple of filesystems and swaps.
//
// Filesystems is a hash of mountpoint and { device, fsType, options } Swaps is a hash of device
// and { options }
fn parse_fstab(fstab: impl BufRead) -> (HashMap<String, Filesystem>, HashMap<String, Swap>) {
    let mut filesystems = HashMap::new();
    let mut swaps = HashMap::new();

    for line in fstab.lines() {
        let Ok(line) = line else {
            break;
        };

        if line.contains('#') {
            continue;
        }

        let mut split = line.split_whitespace();
        let (Some(device), Some(mountpoint), Some(fs_type), options) = (
            split.next(),
            split.next(),
            split.next(),
            split.next().unwrap_or_default(),
        ) else {
            continue;
        };

        if fs_type == "swap" {
            swaps.insert(device.to_string(), Swap(options.to_string()));
        } else {
            filesystems.insert(
                mountpoint.to_string(),
                Filesystem {
                    device: device.to_string(),
                    fs_type: fs_type.to_string(),
                    options: options.to_string(),
                },
            );
        }
    }

    (filesystems, swaps)
}

// Converts a path to the name of a systemd mount unit that would be responsible for mounting this
// path.
fn path_to_unit_name(bin_path: &Path, path: &str) -> String {
    let Ok(output) = std::process::Command::new(bin_path.join("systemd-escape"))
        .arg("--suffix=mount")
        .arg("-p")
        .arg(path)
        .output()
    else {
        eprintln!("Unable to escape {}!", path);
        die();
    };

    let Ok(unit) = String::from_utf8(output.stdout) else {
        eprintln!("Unable to convert systemd-espape output to valid UTF-8");
        die();
    };

    unit.trim().to_string()
}

// Returns a HashMap containing the same contents as the passed in `units`, minus the units in
// `units_to_filter`.
fn filter_units(
    units_to_filter: &HashMap<String, ()>,
    units: &HashMap<String, ()>,
) -> HashMap<String, ()> {
    let mut res = HashMap::new();

    for unit in units.keys() {
        if !units_to_filter.contains_key(unit) {
            res.insert(unit.to_string(), ());
        }
    }

    res
}

fn unit_is_active(conn: &LocalConnection, unit: &str) -> Result<bool> {
    let unit_object_path = conn
        .with_proxy(
            "org.freedesktop.systemd1",
            "/org/freedesktop/systemd1",
            Duration::from_millis(5000),
        )
        .get_unit(unit)
        .with_context(|| format!("Failed to get unit {unit}"))?;

    let active_state: String = conn
        .with_proxy(
            "org.freedesktop.systemd1",
            unit_object_path,
            Duration::from_millis(5000),
        )
        .get("org.freedesktop.systemd1.Unit", "ActiveState")
        .with_context(|| format!("Failed to get ExecMainStatus for {unit}"))?;

    Ok(matches!(active_state.as_str(), "active" | "activating"))
}

static ACTION: OnceLock<Action> = OnceLock::new();

#[derive(Debug)]
enum Job {
    Start,
    Restart,
    Reload,
    Stop,
}

impl std::fmt::Display for Job {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}",
            match self {
                Job::Start => "start",
                Job::Restart => "restart",
                Job::Reload => "reload",
                Job::Stop => "stop",
            }
        )
    }
}

fn new_dbus_proxies(
    conn: &LocalConnection,
) -> (
    Proxy<'_, &LocalConnection>,
    Proxy<'_, &LocalConnection>,
) {
    (
        conn.with_proxy(
            "org.freedesktop.systemd1",
            "/org/freedesktop/systemd1",
            Duration::from_millis(5000),
        ),
        conn.with_proxy(
            "org.freedesktop.login1",
            "/org/freedesktop/login1",
            Duration::from_millis(5000),
        ),
    )
}

fn block_on_jobs(
    conn: &LocalConnection,
    submitted_jobs: &Rc<RefCell<HashMap<dbus::Path<'static>, Job>>>,
) {
    while !submitted_jobs.borrow().is_empty() {
        _ = conn.process(Duration::from_millis(500));
    }
}

fn remove_file_if_exists(p: impl AsRef<Path>) -> std::io::Result<()> {
    match std::fs::remove_file(p) {
        Err(err) if err.kind() != std::io::ErrorKind::NotFound => Err(err),
        _ => Ok(()),
    }
}

/// Performs switch-to-configuration functionality for a single non-root user
fn do_user_switch(parent_exe: String) -> anyhow::Result<()> {
    if Path::new(&parent_exe)
        != Path::new("/proc/self/exe")
            .canonicalize()
            .context("Failed to get full path to current executable")?
            .as_path()
    {
        eprintln!(
            r#"This program is not meant to be called from outside of switch-to-configuration."#
        );
        die();
    }

    let dbus_conn = LocalConnection::new_session().context("Failed to open dbus connection")?;
    let (systemd, _) = new_dbus_proxies(&dbus_conn);

    let nixos_activation_done = Rc::new(RefCell::new(false));
    let _nixos_activation_done = nixos_activation_done.clone();
    let jobs_token = systemd
        .match_signal(
            move |signal: OrgFreedesktopSystemd1ManagerJobRemoved,
                  _: &LocalConnection,
                  _: &Message| {
                if signal.unit.as_str() == "nixos-activation.service" {
                    *_nixos_activation_done.borrow_mut() = true;
                }

                true
            },
        )
        .context("Failed to add signal match for systemd removed jobs")?;

    // The systemd user session seems to not send a Reloaded signal, so we don't have anything to
    // wait on here.
    _ = systemd.reexecute();

    systemd
        .restart_unit("nixos-activation.service", "replace")
        .context("Failed to restart nixos-activation.service")?;

    while !*nixos_activation_done.borrow() {
        _ = dbus_conn
            .process(Duration::from_secs(500))
            .context("Failed to process dbus messages")?;
    }

    dbus_conn
        .remove_match(jobs_token)
        .context("Failed to remove jobs token")?;

    Ok(())
}

fn usage(argv0: &str) -> ! {
    eprintln!(
        r#"Usage: {} [check|switch|boot|test|dry-activate]
check:        run pre-switch checks and exit
switch:       make the configuration the boot default and activate now
boot:         make the configuration the boot default
test:         activate the configuration, but don't make it the boot default
dry-activate: show what would be done if this configuration were activated
"#,
        argv0
    );
    std::process::exit(1);
}

/// Performs switch-to-configuration functionality for the entire system
fn do_system_switch(action: Action) -> anyhow::Result<()> {
    let out = PathBuf::from(required_env("OUT")?);
    let toplevel = PathBuf::from(required_env("TOPLEVEL")?);
    let distro_id = required_env("DISTRO_ID")?;
    let pre_switch_check = required_env("PRE_SWITCH_CHECK")?;
    let install_bootloader = required_env("INSTALL_BOOTLOADER")?;
    let locale_archive = required_env("LOCALE_ARCHIVE")?;
    let new_systemd = PathBuf::from(required_env("SYSTEMD")?);

    let action = ACTION.get_or_init(|| action);

    // The action that is to be performed (like switch, boot, test, dry-activate) Also exposed via
    // environment variable from now on
    std::env::set_var("NIXOS_ACTION", Into::<&'static str>::into(action));

    // Expose the locale archive as an environment variable for systemctl and the activation script
    if !locale_archive.is_empty() {
        std::env::set_var("LOCALE_ARCHIVE", locale_archive);
    }

    let os_release = parse_os_release().context("Failed to parse os-release")?;

    let distro_id_re = Regex::new(format!("^\"?{}\"?$", distro_id).as_str())
        .context("Invalid regex for distro ID")?;

    // This is a NixOS installation if it has /etc/NIXOS or a proper /etc/os-release.
    if !Path::new("/etc/NIXOS").is_file()
        && !os_release
            .get("ID")
            .map(|id| distro_id_re.is_match(id))
            .unwrap_or_default()
    {
        eprintln!("This is not a NixOS installation!");
        die();
    }

    std::fs::create_dir_all("/run/nixos").context("Failed to create /run/nixos directory")?;
    let perms = std::fs::Permissions::from_mode(0o755);
    std::fs::set_permissions("/run/nixos", perms)
        .context("Failed to set permissions on /run/nixos directory")?;

    let Ok(lock) = std::fs::OpenOptions::new()
        .append(true)
        .create(true)
        .open("/run/nixos/switch-to-configuration.lock")
    else {
        eprintln!("Could not open lock");
        die();
    };

    let Ok(_lock) = Flock::lock(lock, FlockArg::LockExclusive) else {
        eprintln!("Could not acquire lock");
        die();
    };

    if syslog::init(Facility::LOG_USER, LevelFilter::Debug, Some("nixos")).is_err() {
        bail!("Failed to initialize logger");
    }

    if std::env::var("NIXOS_NO_CHECK")
        .as_deref()
        .unwrap_or_default()
        != "1"
    {
        do_pre_switch_check(&pre_switch_check, &toplevel)?;
    }

    if *action == Action::Check {
        return Ok(());
    }

    // Install or update the bootloader.
    if matches!(action, Action::Switch | Action::Boot) {
        do_install_bootloader(&install_bootloader, &toplevel)?;
    }

    // Just in case the new configuration hangs the system, do a sync now.
    if std::env::var("NIXOS_NO_SYNC")
        .as_deref()
        .unwrap_or_default()
        != "1"
    {
        let fd = nix::fcntl::open("/nix/store", OFlag::O_NOCTTY, Mode::S_IROTH)
            .context("Failed to open /nix/store")?;
        nix::unistd::syncfs(fd).context("Failed to sync /nix/store")?;
    }

    if *action == Action::Boot {
        std::process::exit(0);
    }

    // Needs to be after the "boot" action exits, as this directory will not exist when doing a NIXOS_LUSTRATE install
    let current_system_bin = std::path::PathBuf::from("/run/current-system/sw/bin")
        .canonicalize()
        .context("/run/current-system/sw/bin is missing")?;

    let current_init_interface_version =
        std::fs::read_to_string("/run/current-system/init-interface-version").unwrap_or_default();

    let new_init_interface_version =
        std::fs::read_to_string(toplevel.join("init-interface-version"))
            .context("File init-interface-version should exist")?;

    // Check if we can activate the new configuration.
    if current_init_interface_version != new_init_interface_version {
        eprintln!(
            r#"Warning: the new NixOS configuration has an ‘init’ that is
incompatible with the current configuration.  The new configuration
won't take effect until you reboot the system.
"#
        );
        std::process::exit(100);
    }

    // Ignore SIGHUP so that we're not killed if we're running on (say) virtual console 1 and we
    // restart the "tty1" unit.
    let handler = SigHandler::Handler(handle_sigpipe);
    unsafe { signal::signal(Signal::SIGPIPE, handler) }.context("Failed to set SIGPIPE handler")?;

    let mut units_to_stop = HashMap::new();
    let mut units_to_skip = HashMap::new();
    let mut units_to_filter = HashMap::new(); // units not shown

    let mut units_to_start = map_from_list_file(START_LIST_FILE);
    let mut units_to_restart = map_from_list_file(RESTART_LIST_FILE);
    let mut units_to_reload = map_from_list_file(RELOAD_LIST_FILE);

    let dbus_conn = LocalConnection::new_system().context("Failed to open dbus connection")?;
    let (systemd, logind) = new_dbus_proxies(&dbus_conn);

    let submitted_jobs = Rc::new(RefCell::new(HashMap::new()));
    let finished_jobs = Rc::new(RefCell::new(HashMap::new()));

    let systemd_reload_status = Rc::new(RefCell::new(false));

    systemd
        .subscribe()
        .context("Failed to subscribe to systemd dbus messages")?;

    let _systemd_reload_status = systemd_reload_status.clone();
    let reloading_token = systemd
        .match_signal(
            move |signal: OrgFreedesktopSystemd1ManagerReloading,
                  _: &LocalConnection,
                  _msg: &Message| {
                *_systemd_reload_status.borrow_mut() = signal.active;

                true
            },
        )
        .context("Failed to add systemd Reloading match")?;

    let _submitted_jobs = submitted_jobs.clone();
    let _finished_jobs = finished_jobs.clone();
    let job_removed_token = systemd
        .match_signal(
            move |signal: OrgFreedesktopSystemd1ManagerJobRemoved,
                  _: &LocalConnection,
                  _msg: &Message| {
                if let Some(old) = _submitted_jobs.borrow_mut().remove(&signal.job) {
                    let mut finished_jobs = _finished_jobs.borrow_mut();
                    finished_jobs.insert(signal.job, (signal.unit, old, signal.result));
                }

                true
            },
        )
        .context("Failed to add systemd JobRemoved match")?;

    let current_active_units = get_active_units(&systemd)?;

    let template_unit_re = Regex::new(r"^(.*)@[^\.]*\.(.*)$")
        .context("Invalid regex for matching systemd template units")?;
    let unit_name_re = Regex::new(r"^(.*)\.[[:lower:]]*$")
        .context("Invalid regex for matching systemd unit names")?;

    for (unit, unit_state) in &current_active_units {
        let current_unit_file = Path::new("/etc/systemd/system").join(unit);
        let new_unit_file = toplevel.join("etc/systemd/system").join(unit);

        let mut base_unit = unit.clone();
        let mut current_base_unit_file = current_unit_file.clone();
        let mut new_base_unit_file = new_unit_file.clone();

        // Detect template instances
        if let Some((Some(template_name), Some(template_instance))) =
            template_unit_re.captures(unit).map(|captures| {
                (
                    captures.get(1).map(|c| c.as_str()),
                    captures.get(2).map(|c| c.as_str()),
                )
            })
        {
            if !current_unit_file.exists() && !new_unit_file.exists() {
                base_unit = format!("{}@.{}", template_name, template_instance);
                current_base_unit_file = Path::new("/etc/systemd/system").join(&base_unit);
                new_base_unit_file = toplevel.join("etc/systemd/system").join(&base_unit);
            }
        }

        let mut base_name = base_unit.as_str();
        if let Some(Some(new_base_name)) = unit_name_re
            .captures(&base_unit)
            .map(|capture| capture.get(1).map(|first| first.as_str()))
        {
            base_name = new_base_name;
        }

        if current_base_unit_file.exists()
            && (unit_state.state == "active" || unit_state.state == "activating")
        {
            if new_base_unit_file
                .canonicalize()
                .map(|full_path| full_path == Path::new("/dev/null"))
                .unwrap_or(true)
            {
                let current_unit_info = parse_unit(&current_unit_file, &current_base_unit_file)?;
                if parse_systemd_bool(Some(&current_unit_info), "Unit", "X-StopOnRemoval", true) {
                    _ = units_to_stop.insert(unit.to_string(), ());
                }
            } else if unit.ends_with(".target") {
                let new_unit_info = parse_unit(&new_unit_file, &new_base_unit_file)?;

                // Cause all active target units to be restarted below. This should start most
                // changed units we stop here as well as any new dependencies (including new mounts
                // and swap devices).  FIXME: the suspend target is sometimes active after the
                // system has resumed, which probably should not be the case.  Just ignore it.
                if !(matches!(
                    unit.as_str(),
                    "suspend.target" | "hibernate.target" | "hybrid-sleep.target"
                ) || parse_systemd_bool(
                        Some(&new_unit_info),
                        "Unit",
                        "RefuseManualStart",
                        false,
                    ) || parse_systemd_bool(
                        Some(&new_unit_info),
                        "Unit",
                        "X-OnlyManualStart",
                        false,
                    )) {
                    units_to_start.insert(unit.to_string(), ());
                    record_unit(START_LIST_FILE, unit);
                    // Don't spam the user with target units that always get started.
                    if std::env::var("STC_DISPLAY_ALL_UNITS").as_deref() != Ok("1") {
                        units_to_filter.insert(unit.to_string(), ());
                    }
                }

                // Stop targets that have X-StopOnReconfiguration set. This is necessary to respect
                // dependency orderings involving targets: if unit X starts after target Y and
                // target Y starts after unit Z, then if X and Z have both changed, then X should
                // be restarted after Z.  However, if target Y is in the "active" state, X and Z
                // will be restarted at the same time because X's dependency on Y is already
                // satisfied.  Thus, we need to stop Y first. Stopping a target generally has no
                // effect on other units (unless there is a PartOf dependency), so this is just a
                // bookkeeping thing to get systemd to do the right thing.
                if parse_systemd_bool(
                    Some(&new_unit_info),
                    "Unit",
                    "X-StopOnReconfiguration",
                    false,
                ) {
                    units_to_stop.insert(unit.to_string(), ());
                }
            } else {
                let current_unit_info = parse_unit(&current_unit_file, &current_base_unit_file)?;
                let new_unit_info = parse_unit(&new_unit_file, &new_base_unit_file)?;
                match compare_units(&current_unit_info, &new_unit_info) {
                    UnitComparison::UnequalNeedsRestart => {
                        handle_modified_unit(
                            &toplevel,
                            unit,
                            base_name,
                            &new_unit_file,
                            &new_base_unit_file,
                            Some(&new_unit_info),
                            &current_active_units,
                            &mut units_to_stop,
                            &mut units_to_start,
                            &mut units_to_reload,
                            &mut units_to_restart,
                            &mut units_to_skip,
                        )?;
                    }
                    UnitComparison::UnequalNeedsReload if !units_to_restart.contains_key(unit) => {
                        units_to_reload.insert(unit.clone(), ());
                        record_unit(RELOAD_LIST_FILE, unit);
                    }
                    _ => {}
                }
            }
        }
    }

    // Compare the previous and new fstab to figure out which filesystems need a remount or need to
    // be unmounted. New filesystems are mounted automatically by starting local-fs.target.
    // FIXME: might be nicer if we generated units for all mounts; then we could unify this with
    // the unit checking code above.
    let (current_filesystems, current_swaps) = std::fs::read_to_string("/etc/fstab")
        .map(|fstab| parse_fstab(std::io::Cursor::new(fstab)))
        .unwrap_or_default();
    let (new_filesystems, new_swaps) = std::fs::read_to_string(toplevel.join("etc/fstab"))
        .map(|fstab| parse_fstab(std::io::Cursor::new(fstab)))
        .unwrap_or_default();

    for (mountpoint, current_filesystem) in current_filesystems {
        // Use current version of systemctl binary before daemon is reexeced.
        let unit = path_to_unit_name(&current_system_bin, &mountpoint);
        if let Some(new_filesystem) = new_filesystems.get(&mountpoint) {
            if current_filesystem.fs_type != new_filesystem.fs_type
                || current_filesystem.device != new_filesystem.device
            {
                if matches!(mountpoint.as_str(), "/" | "/nix") {
                    if current_filesystem.options != new_filesystem.options {
                        // Mount options changes, so remount it.
                        units_to_reload.insert(unit.to_string(), ());
                        record_unit(RELOAD_LIST_FILE, &unit)
                    } else {
                        // Don't unmount / or /nix if the device changed
                        units_to_skip.insert(unit, ());
                    }
                } else {
                    // Filesystem type or device changed, so unmount and mount it.
                    units_to_restart.insert(unit.to_string(), ());
                    record_unit(RESTART_LIST_FILE, &unit);
                }
            } else if current_filesystem.options != new_filesystem.options {
                // Mount options changes, so remount it.
                units_to_reload.insert(unit.to_string(), ());
                record_unit(RELOAD_LIST_FILE, &unit)
            }
        } else {
            // Filesystem entry disappeared, so unmount it.
            units_to_stop.insert(unit, ());
        }
    }

    // Also handles swap devices.
    for (device, _) in current_swaps {
        if !new_swaps.contains_key(&device) {
            // Swap entry disappeared, so turn it off.  Can't use "systemctl stop" here because
            // systemd has lots of alias units that prevent a stop from actually calling "swapoff".
            if *action == Action::DryActivate {
                eprintln!("would stop swap device: {}", &device);
            } else {
                eprintln!("stopping swap device: {}", &device);
                let c_device = std::ffi::CString::new(device.clone())
                    .context("failed to convert device to cstring")?;
                if unsafe { nix::libc::swapoff(c_device.as_ptr()) } != 0 {
                    let err = std::io::Error::last_os_error();
                    eprintln!("Failed to stop swapping to {device}: {err}");
                }
            }
        }
        // FIXME: update swap options (i.e. its priority).
    }

    // Should we have systemd re-exec itself?
    let current_pid1_path = Path::new("/proc/1/exe")
        .canonicalize()
        .unwrap_or_else(|_| PathBuf::from("/unknown"));
    let current_systemd_system_config = Path::new("/etc/systemd/system.conf")
        .canonicalize()
        .unwrap_or_else(|_| PathBuf::from("/unknown"));
    let Ok(new_pid1_path) = new_systemd.join("lib/systemd/systemd").canonicalize() else {
        die();
    };
    let new_systemd_system_config = toplevel
        .join("etc/systemd/system.conf")
        .canonicalize()
        .unwrap_or_else(|_| PathBuf::from("/unknown"));

    let restart_systemd = current_pid1_path != new_pid1_path
        || current_systemd_system_config != new_systemd_system_config;

    let units_to_stop_filtered = filter_units(&units_to_filter, &units_to_stop);

    // Show dry-run actions.
    if *action == Action::DryActivate {
        if !units_to_stop_filtered.is_empty() {
            let mut units = units_to_stop_filtered
                .keys()
                .map(String::as_str)
                .collect::<Vec<&str>>();
            units.sort_by_key(|name| name.to_lowercase());
            eprintln!("would stop the following units: {}", units.join(", "));
        }

        if !units_to_skip.is_empty() {
            let mut units = units_to_skip
                .keys()
                .map(String::as_str)
                .collect::<Vec<&str>>();
            units.sort_by_key(|name| name.to_lowercase());
            eprintln!(
                "would NOT stop the following changed units: {}",
                units.join(", ")
            );
        }

        eprintln!("would activate the configuration...");
        _ = std::process::Command::new(out.join("dry-activate"))
            .arg(&out)
            .spawn()
            .map(|mut child| child.wait());

        // Handle the activation script requesting the restart or reload of a unit.
        for unit in std::fs::read_to_string(DRY_RESTART_BY_ACTIVATION_LIST_FILE)
            .unwrap_or_default()
            .lines()
        {
            let current_unit_file = Path::new("/etc/systemd/system").join(unit);
            let new_unit_file = toplevel.join("etc/systemd/system").join(unit);
            let mut base_unit = unit.to_string();
            let mut new_base_unit_file = new_unit_file.clone();

            // Detect template instances.
            if let Some((Some(template_name), Some(template_instance))) =
                template_unit_re.captures(unit).map(|captures| {
                    (
                        captures.get(1).map(|c| c.as_str()),
                        captures.get(2).map(|c| c.as_str()),
                    )
                })
            {
                if !current_unit_file.exists() && !new_unit_file.exists() {
                    base_unit = format!("{}@.{}", template_name, template_instance);
                    new_base_unit_file = toplevel.join("etc/systemd/system").join(&base_unit);
                }
            }

            let mut base_name = base_unit.as_str();
            if let Some(Some(new_base_name)) = unit_name_re
                .captures(&base_unit)
                .map(|capture| capture.get(1).map(|first| first.as_str()))
            {
                base_name = new_base_name;
            }

            // Start units if they were not active previously
            if !current_active_units.contains_key(unit) {
                units_to_start.insert(unit.to_string(), ());
                continue;
            }

            handle_modified_unit(
                &toplevel,
                unit,
                base_name,
                &new_unit_file,
                &new_base_unit_file,
                None,
                &current_active_units,
                &mut units_to_stop,
                &mut units_to_start,
                &mut units_to_reload,
                &mut units_to_restart,
                &mut units_to_skip,
            )?;
        }

        remove_file_if_exists(DRY_RESTART_BY_ACTIVATION_LIST_FILE)
            .with_context(|| format!("Failed to remove {}", DRY_RESTART_BY_ACTIVATION_LIST_FILE))?;

        for unit in std::fs::read_to_string(DRY_RELOAD_BY_ACTIVATION_LIST_FILE)
            .unwrap_or_default()
            .lines()
        {
            if current_active_units.contains_key(unit)
                && !units_to_restart.contains_key(unit)
                && !units_to_stop.contains_key(unit)
            {
                units_to_reload.insert(unit.to_string(), ());
                record_unit(RELOAD_LIST_FILE, unit);
            }
        }

        remove_file_if_exists(DRY_RELOAD_BY_ACTIVATION_LIST_FILE)
            .with_context(|| format!("Failed to remove {}", DRY_RELOAD_BY_ACTIVATION_LIST_FILE))?;

        if restart_systemd {
            eprintln!("would restart systemd");
        }

        if !units_to_reload.is_empty() {
            let mut units = units_to_reload
                .keys()
                .map(String::as_str)
                .collect::<Vec<&str>>();
            units.sort_by_key(|name| name.to_lowercase());
            eprintln!("would reload the following units: {}", units.join(", "));
        }

        if !units_to_restart.is_empty() {
            let mut units = units_to_restart
                .keys()
                .map(String::as_str)
                .collect::<Vec<&str>>();
            units.sort_by_key(|name| name.to_lowercase());
            eprintln!("would restart the following units: {}", units.join(", "));
        }

        let units_to_start_filtered = filter_units(&units_to_filter, &units_to_start);
        if !units_to_start_filtered.is_empty() {
            let mut units = units_to_start_filtered
                .keys()
                .map(String::as_str)
                .collect::<Vec<&str>>();
            units.sort_by_key(|name| name.to_lowercase());
            eprintln!("would start the following units: {}", units.join(", "));
        }

        std::process::exit(0);
    }

    log::info!("switching to system configuration {}", toplevel.display());

    if !units_to_stop.is_empty() {
        if !units_to_stop_filtered.is_empty() {
            let mut units = units_to_stop_filtered
                .keys()
                .map(String::as_str)
                .collect::<Vec<&str>>();
            units.sort_by_key(|name| name.to_lowercase());
            eprintln!("stopping the following units: {}", units.join(", "));
        }

        for unit in units_to_stop.keys() {
            if let Ok(job_path) = systemd.stop_unit(unit, "replace") {
                let mut j = submitted_jobs.borrow_mut();
                j.insert(job_path.to_owned(), Job::Stop);
            };
        }

        block_on_jobs(&dbus_conn, &submitted_jobs);
    }

    if !units_to_skip.is_empty() {
        let mut units = units_to_skip
            .keys()
            .map(String::as_str)
            .collect::<Vec<&str>>();
        units.sort_by_key(|name| name.to_lowercase());
        eprintln!(
            "NOT restarting the following changed units: {}",
            units.join(", "),
        );
    }

    // Wait for all stop jobs to finish
    block_on_jobs(&dbus_conn, &submitted_jobs);

    let mut exit_code = 0;

    // Activate the new configuration (i.e., update /etc, make accounts, and so on).
    eprintln!("activating the configuration...");
    match std::process::Command::new(out.join("activate"))
        .arg(&out)
        .spawn()
        .map(|mut child| child.wait())
    {
        Ok(Ok(status)) if status.success() => {}
        Err(_) => {
            // allow toplevel to not have an activation script
        }
        _ => {
            eprintln!("Failed to run activate script");
            exit_code = 2;
        }
    }

    // Handle the activation script requesting the restart or reload of a unit.
    for unit in std::fs::read_to_string(RESTART_BY_ACTIVATION_LIST_FILE)
        .unwrap_or_default()
        .lines()
    {
        let new_unit_file = toplevel.join("etc/systemd/system").join(unit);
        let mut base_unit = unit.to_string();
        let mut new_base_unit_file = new_unit_file.clone();

        // Detect template instances.
        if let Some((Some(template_name), Some(template_instance))) =
            template_unit_re.captures(unit).map(|captures| {
                (
                    captures.get(1).map(|c| c.as_str()),
                    captures.get(2).map(|c| c.as_str()),
                )
            })
        {
            if !new_unit_file.exists() {
                base_unit = format!("{}@.{}", template_name, template_instance);
                new_base_unit_file = toplevel.join("etc/systemd/system").join(&base_unit);
            }
        }

        let mut base_name = base_unit.as_str();
        if let Some(Some(new_base_name)) = unit_name_re
            .captures(&base_unit)
            .map(|capture| capture.get(1).map(|first| first.as_str()))
        {
            base_name = new_base_name;
        }

        // Start units if they were not active previously
        if !current_active_units.contains_key(unit) {
            units_to_start.insert(unit.to_string(), ());
            record_unit(START_LIST_FILE, unit);
            continue;
        }

        handle_modified_unit(
            &toplevel,
            unit,
            base_name,
            &new_unit_file,
            &new_base_unit_file,
            None,
            &current_active_units,
            &mut units_to_stop,
            &mut units_to_start,
            &mut units_to_reload,
            &mut units_to_restart,
            &mut units_to_skip,
        )?;
    }

    // We can remove the file now because it has been propagated to the other restart/reload files
    remove_file_if_exists(RESTART_BY_ACTIVATION_LIST_FILE)
        .with_context(|| format!("Failed to remove {}", RESTART_BY_ACTIVATION_LIST_FILE))?;

    for unit in std::fs::read_to_string(RELOAD_BY_ACTIVATION_LIST_FILE)
        .unwrap_or_default()
        .lines()
    {
        if current_active_units.contains_key(unit)
            && !units_to_restart.contains_key(unit)
            && !units_to_stop.contains_key(unit)
        {
            units_to_reload.insert(unit.to_string(), ());
            record_unit(RELOAD_LIST_FILE, unit);
        }
    }

    // We can remove the file now because it has been propagated to the other reload file
    remove_file_if_exists(RELOAD_BY_ACTIVATION_LIST_FILE)
        .with_context(|| format!("Failed to remove {}", RELOAD_BY_ACTIVATION_LIST_FILE))?;

    // Restart systemd if necessary. Note that this is done using the current version of systemd,
    // just in case the new one has trouble communicating with the running pid 1.
    if restart_systemd {
        eprintln!("restarting systemd...");
        _ = systemd.reexecute(); // we don't get a dbus reply here

        while !*systemd_reload_status.borrow() {
            _ = dbus_conn
                .process(Duration::from_millis(500))
                .context("Failed to process dbus messages")?;
        }
    }

    // Forget about previously failed services.
    systemd
        .reset_failed()
        .context("Failed to reset failed units")?;

    // Make systemd reload its units.
    _ = systemd.reload(); // we don't get a dbus reply here
    while !*systemd_reload_status.borrow() {
        _ = dbus_conn
            .process(Duration::from_millis(500))
            .context("Failed to process dbus messages")?;
    }

    dbus_conn
        .remove_match(reloading_token)
        .context("Failed to cleanup systemd Reloading match")?;

    // Reload user units
    match logind.list_users() {
        Err(err) => {
            eprintln!("Unable to list users with logind: {err}");
            die();
        }
        Ok(users) => {
            for (uid, name, user_dbus_path) in users {
                let proxy = dbus_conn.with_proxy(
                    "org.freedesktop.login1",
                    &user_dbus_path,
                    Duration::from_millis(5000),
                );
                let gid: u32 = proxy
                    .get("org.freedesktop.login1.User", "GID")
                    .with_context(|| format!("Failed to get GID for {name}"))?;

                let runtime_path: String = proxy
                    .get("org.freedesktop.login1.User", "RuntimePath")
                    .with_context(|| format!("Failed to get runtime directory for {name}"))?;

                eprintln!("reloading user units for {}...", name);
                let myself = Path::new("/proc/self/exe")
                    .canonicalize()
                    .context("Failed to get full path to /proc/self/exe")?;

                std::process::Command::new(&myself)
                    .uid(uid)
                    .gid(gid)
                    .env_clear()
                    .env("XDG_RUNTIME_DIR", runtime_path)
                    .env("__NIXOS_SWITCH_TO_CONFIGURATION_PARENT_EXE", &myself)
                    .spawn()
                    .with_context(|| format!("Failed to spawn user activation for {name}"))?
                    .wait()
                    .with_context(|| format!("Failed to run user activation for {name}"))?;
            }
        }
    }

    // Restart sysinit-reactivation.target. This target only exists to restart services ordered
    // before sysinit.target. We cannot use X-StopOnReconfiguration to restart sysinit.target
    // because then ALL services of the system would be restarted since all normal services have a
    // default dependency on sysinit.target. sysinit-reactivation.target ensures that services
    // ordered BEFORE sysinit.target get re-started in the correct order. Ordering between these
    // services is respected.
    eprintln!("restarting {SYSINIT_REACTIVATION_TARGET}");
    match systemd.restart_unit(SYSINIT_REACTIVATION_TARGET, "replace") {
        Ok(job_path) => {
            let mut jobs = submitted_jobs.borrow_mut();
            jobs.insert(job_path, Job::Restart);
        }
        Err(err) => {
            eprintln!("Failed to restart {SYSINIT_REACTIVATION_TARGET}: {err}");
            exit_code = 4;
        }
    }

    // Wait for the restart job of sysinit-reactivation.service to finish
    block_on_jobs(&dbus_conn, &submitted_jobs);

    // Before reloading we need to ensure that the units are still active. They may have been
    // deactivated because one of their requirements got stopped. If they are inactive but should
    // have been reloaded, the user probably expects them to be started.
    if !units_to_reload.is_empty() {
        for (unit, _) in units_to_reload.clone() {
            if !unit_is_active(&dbus_conn, &unit)? {
                // Figure out if we need to start the unit
                let unit_info = parse_unit(
                    toplevel.join("etc/systemd/system").join(&unit).as_path(),
                    toplevel.join("etc/systemd/system").join(&unit).as_path(),
                )?;
                if !parse_systemd_bool(Some(&unit_info), "Unit", "RefuseManualStart", false)
                    || parse_systemd_bool(Some(&unit_info), "Unit", "X-OnlyManualStart", false)
                {
                    units_to_start.insert(unit.clone(), ());
                    record_unit(START_LIST_FILE, &unit);
                }
                // Don't reload the unit, reloading would fail
                units_to_reload.remove(&unit);
                unrecord_unit(RELOAD_LIST_FILE, &unit);
            }
        }
    }

    // Reload units that need it. This includes remounting changed mount units.
    if !units_to_reload.is_empty() {
        let mut units = units_to_reload
            .keys()
            .map(String::as_str)
            .collect::<Vec<&str>>();
        units.sort_by_key(|name| name.to_lowercase());
        eprintln!("reloading the following units: {}", units.join(", "));

        for unit in units {
            match systemd.reload_unit(unit, "replace") {
                Ok(job_path) => {
                    submitted_jobs
                        .borrow_mut()
                        .insert(job_path.clone(), Job::Reload);
                }
                Err(err) => {
                    eprintln!("Failed to reload {unit}: {err}");
                    exit_code = 4;
                }
            }
        }

        block_on_jobs(&dbus_conn, &submitted_jobs);

        remove_file_if_exists(RELOAD_LIST_FILE)
            .with_context(|| format!("Failed to remove {}", RELOAD_LIST_FILE))?;
    }

    // Restart changed services (those that have to be restarted rather than stopped and started).
    if !units_to_restart.is_empty() {
        let mut units = units_to_restart
            .keys()
            .map(String::as_str)
            .collect::<Vec<&str>>();
        units.sort_by_key(|name| name.to_lowercase());
        eprintln!("restarting the following units: {}", units.join(", "));

        for unit in units {
            match systemd.restart_unit(unit, "replace") {
                Ok(job_path) => {
                    let mut jobs = submitted_jobs.borrow_mut();
                    jobs.insert(job_path, Job::Restart);
                }
                Err(err) => {
                    eprintln!("Failed to restart {unit}: {err}");
                    exit_code = 4;
                }
            }
        }

        block_on_jobs(&dbus_conn, &submitted_jobs);

        remove_file_if_exists(RESTART_LIST_FILE)
            .with_context(|| format!("Failed to remove {}", RESTART_LIST_FILE))?;
    }

    // Start all active targets, as well as changed units we stopped above. The latter is necessary
    // because some may not be dependencies of the targets (i.e., they were manually started).
    // FIXME: detect units that are symlinks to other units.  We shouldn't start both at the same
    // time because we'll get a "Failed to add path to set" error from systemd.
    let units_to_start_filtered = filter_units(&units_to_filter, &units_to_start);
    if !units_to_start_filtered.is_empty() {
        let mut units = units_to_start_filtered
            .keys()
            .map(String::as_str)
            .collect::<Vec<&str>>();
        units.sort_by_key(|name| name.to_lowercase());
        eprintln!("starting the following units: {}", units.join(", "));
    }

    for unit in units_to_start.keys() {
        match systemd.start_unit(unit, "replace") {
            Ok(job_path) => {
                let mut jobs = submitted_jobs.borrow_mut();
                jobs.insert(job_path, Job::Start);
            }
            Err(err) => {
                eprintln!("Failed to start {unit}: {err}");
                exit_code = 4;
            }
        }
    }

    block_on_jobs(&dbus_conn, &submitted_jobs);

    remove_file_if_exists(START_LIST_FILE)
        .with_context(|| format!("Failed to remove {}", START_LIST_FILE))?;

    for (unit, job, result) in finished_jobs.borrow().values() {
        match result.as_str() {
            "timeout" | "failed" | "dependency" => {
                eprintln!("Failed to {} {}", job, unit);
                exit_code = 4;
            }
            _ => {}
        }
    }

    dbus_conn
        .remove_match(job_removed_token)
        .context("Failed to cleanup systemd job match")?;

    // Print failed and new units.
    let mut failed_units = Vec::new();
    let mut new_units = Vec::new();

    // NOTE: We want switch-to-configuration to be able to report to the user any units that failed
    // to start or units that systemd had to restart due to having previously failed. This is
    // inherently a race condition between how long our program takes to run and how long the unit
    // in question takes to potentially fail. The amount of time we wait for new messages on the
    // bus to settle is purely tuned so that this program is compatible with the Perl
    // implementation.
    //
    // Wait for events from systemd to settle. process() will return true if we have received any
    // messages on the bus.
    while dbus_conn
        .process(Duration::from_millis(250))
        .unwrap_or_default()
    {}

    let new_active_units = get_active_units(&systemd)?;

    for (unit, unit_state) in new_active_units {
        if &unit_state.state == "failed" {
            failed_units.push(unit);
            continue;
        }

        if unit_state.substate == "auto-restart" && unit.ends_with(".service") {
            // A unit in auto-restart substate is a failure *if* it previously failed to start
            let unit_object_path = systemd
                .get_unit(&unit)
                .with_context(|| format!("Failed to get unit info for {unit}"))?;
            let exec_main_status: i32 = dbus_conn
                .with_proxy(
                    "org.freedesktop.systemd1",
                    unit_object_path,
                    Duration::from_millis(5000),
                )
                .get("org.freedesktop.systemd1.Service", "ExecMainStatus")
                .with_context(|| format!("Failed to get ExecMainStatus for {unit}"))?;

            if exec_main_status != 0 {
                failed_units.push(unit);
                continue;
            }
        }

        // Ignore scopes since they are not managed by this script but rather created and managed
        // by third-party services via the systemd dbus API. This only lists units that are not
        // failed (including ones that are in auto-restart but have not failed previously)
        if unit_state.state != "failed"
            && !current_active_units.contains_key(&unit)
            && !unit.ends_with(".scope")
        {
            new_units.push(unit);
        }
    }

    if !new_units.is_empty() {
        new_units.sort_by_key(|name| name.to_lowercase());
        eprintln!(
            "the following new units were started: {}",
            new_units.join(", ")
        );
    }

    if !failed_units.is_empty() {
        failed_units.sort_by_key(|name| name.to_lowercase());
        eprintln!(
            "warning: the following units failed: {}",
            failed_units.join(", ")
        );
        _ = std::process::Command::new(new_systemd.join("bin/systemctl"))
            .arg("status")
            .arg("--no-pager")
            .arg("--full")
            .args(failed_units)
            .spawn()
            .map(|mut child| child.wait());

        exit_code = 4;
    }

    if exit_code == 0 {
        log::info!(
            "finished switching to system configuration {}",
            toplevel.display()
        );
    } else {
        log::error!(
            "switching to system configuration {} failed (status {})",
            toplevel.display(),
            exit_code
        );
    }

    std::process::exit(exit_code);
}

fn main() -> anyhow::Result<()> {
    match std::env::var("__NIXOS_SWITCH_TO_CONFIGURATION_PARENT_EXE").ok() {
        Some(parent_exe) => do_user_switch(parent_exe),
        None => {
            let mut args = std::env::args();
            let argv0 = args.next().ok_or(anyhow!("no argv[0]"))?;
            let argv0 = argv0
                .split(std::path::MAIN_SEPARATOR_STR)
                .last()
                .unwrap_or("switch-to-configuration");

            let Some(Ok(action)) = args.next().map(|a| Action::from_str(&a)) else {
                usage(argv0);
            };

            if unsafe { nix::libc::geteuid() } == 0 {
                do_system_switch(action)
            } else {
                bail!("{} must be run as the root user", argv0);
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use std::collections::HashMap;

    #[test]
    fn parse_fstab() {
        {
            let (filesystems, swaps) = super::parse_fstab(std::io::Cursor::new(""));
            assert!(filesystems.is_empty());
            assert!(swaps.is_empty());
        }

        {
            let (filesystems, swaps) = super::parse_fstab(std::io::Cursor::new(
                r#"\
invalid
                    "#,
            ));
            assert!(filesystems.is_empty());
            assert!(swaps.is_empty());
        }

        {
            let (filesystems, swaps) = super::parse_fstab(std::io::Cursor::new(
                r#"\
# This is a generated file.  Do not edit!
#
# To make changes, edit the fileSystems and swapDevices NixOS options
# in your /etc/nixos/configuration.nix file.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>

# Filesystems.
/dev/mapper/root / btrfs x-initrd.mount,compress=zstd,noatime,defaults 0 0
/dev/disk/by-partlabel/BOOT /boot vfat x-systemd.automount 0 2
/dev/disk/by-partlabel/home /home ext4 defaults 0 2
/dev/mapper/usr /nix/.ro-store erofs x-initrd.mount,ro 0 2


# Swap devices.
                    "#,
            ));
            assert_eq!(filesystems.len(), 4);
            assert_eq!(swaps.len(), 0);
            let home_fs = filesystems.get("/home").unwrap();
            assert_eq!(home_fs.fs_type, "ext4");
            assert_eq!(home_fs.device, "/dev/disk/by-partlabel/home");
            assert_eq!(home_fs.options, "defaults");
        }
    }

    #[test]
    fn filter_units() {
        assert_eq!(
            super::filter_units(&HashMap::from([]), &HashMap::from([])),
            HashMap::from([])
        );

        assert_eq!(
            super::filter_units(
                &HashMap::from([("foo".to_string(), ())]),
                &HashMap::from([("foo".to_string(), ()), ("bar".to_string(), ())])
            ),
            HashMap::from([("bar".to_string(), ())])
        );
    }

    #[test]
    fn compare_units() {
        {
            assert!(
                super::compare_units(&HashMap::from([]), &HashMap::from([]))
                    == super::UnitComparison::Equal
            );

            assert!(
                super::compare_units(
                    &HashMap::from([("Unit".to_string(), HashMap::from([]))]),
                    &HashMap::from([])
                ) == super::UnitComparison::Equal
            );

            assert!(
                super::compare_units(
                    &HashMap::from([(
                        "Unit".to_string(),
                        HashMap::from([(
                            "X-Reload-Triggers".to_string(),
                            vec!["foobar".to_string()]
                        )])
                    )]),
                    &HashMap::from([])
                ) == super::UnitComparison::Equal
            );
        }

        {
            assert!(
                super::compare_units(
                    &HashMap::from([("foobar".to_string(), HashMap::from([]))]),
                    &HashMap::from([])
                ) == super::UnitComparison::UnequalNeedsRestart
            );

            assert!(
                super::compare_units(
                    &HashMap::from([(
                        "Mount".to_string(),
                        HashMap::from([("Options".to_string(), vec![])])
                    )]),
                    &HashMap::from([(
                        "Mount".to_string(),
                        HashMap::from([("Options".to_string(), vec!["ro".to_string()])])
                    )])
                ) == super::UnitComparison::UnequalNeedsReload
            );
        }

        {
            assert!(
                super::compare_units(
                    &HashMap::from([]),
                    &HashMap::from([(
                        "Unit".to_string(),
                        HashMap::from([(
                            "X-Reload-Triggers".to_string(),
                            vec!["foobar".to_string()]
                        )])
                    )])
                ) == super::UnitComparison::UnequalNeedsReload
            );

            assert!(
                super::compare_units(
                    &HashMap::from([(
                        "Unit".to_string(),
                        HashMap::from([(
                            "X-Reload-Triggers".to_string(),
                            vec!["foobar".to_string()]
                        )])
                    )]),
                    &HashMap::from([(
                        "Unit".to_string(),
                        HashMap::from([(
                            "X-Reload-Triggers".to_string(),
                            vec!["barfoo".to_string()]
                        )])
                    )])
                ) == super::UnitComparison::UnequalNeedsReload
            );

            assert!(
                super::compare_units(
                    &HashMap::from([(
                        "Mount".to_string(),
                        HashMap::from([("Type".to_string(), vec!["ext4".to_string()])])
                    )]),
                    &HashMap::from([(
                        "Mount".to_string(),
                        HashMap::from([("Type".to_string(), vec!["btrfs".to_string()])])
                    )])
                ) == super::UnitComparison::UnequalNeedsRestart
            );
        }
    }

    #[test]
    fn parse_systemd_ini() {
        // Ensure we don't attempt to unescape content in unit files.
        // https://github.com/NixOS/nixpkgs/issues/315602
        {
            let mut unit_info = HashMap::new();

            let test_unit = std::io::Cursor::new(
                r#"[Unit]
After=dev-disk-by\x2dlabel-root.device
"#,
            );
            super::parse_systemd_ini(&mut unit_info, test_unit).unwrap();

            assert_eq!(
                unit_info
                    .get("Unit")
                    .unwrap()
                    .get("After")
                    .unwrap()
                    .first()
                    .unwrap(),
                "dev-disk-by\\x2dlabel-root.device"
            );
        }
    }
}
