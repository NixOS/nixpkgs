mod config;
mod subid;

use std::{collections::BTreeSet, io::Write, path::PathBuf, process::ExitCode};

use anyhow::{anyhow, bail, Context, Result};
use log::{Level, LevelFilter};

use config::Config;
use subid::{allocate, find_overlap, Range, SubIdDb};

const DEFAULT_DIRECTORY: &str = "/etc";

fn main() -> ExitCode {
    env_logger::builder()
        .format(|buf, record| {
            writeln!(
                buf,
                "<{}>{}",
                match record.level() {
                    Level::Error => 3,
                    Level::Warn => 4,
                    Level::Info => 6,
                    Level::Debug | Level::Trace => 7,
                },
                record.args()
            )
        })
        .filter(None, LevelFilter::Info)
        .init();

    match run() {
        Ok(()) => ExitCode::SUCCESS,
        Err(err) => {
            log::error!("{err:#}.");
            ExitCode::FAILURE
        }
    }
}

fn run() -> Result<()> {
    let mut args = std::env::args_os().skip(1).peekable();
    let strict = args.next_if(|a| a == "--strict").is_some();
    let config_path = args.next().ok_or_else(|| anyhow!("No config provided"))?;
    let directory: PathBuf = args
        .next()
        .map(PathBuf::from)
        .unwrap_or_else(|| DEFAULT_DIRECTORY.into());
    let config = Config::from_file(config_path)?;

    let subuid_path = directory.join("subuid");
    let subgid_path = directory.join("subgid");

    let mut subuid = SubIdDb::from_file(&subuid_path)?;
    let mut subgid = SubIdDb::from_file(&subgid_path)?;

    apply(&config, &mut subuid, &mut subgid)?;

    check_overlap("subuid", &subuid, strict)?;
    check_overlap("subgid", &subgid, strict)?;

    subuid
        .to_file(&subuid_path)
        .with_context(|| format!("Failed to write {}", subuid_path.display()))?;
    subgid
        .to_file(&subgid_path)
        .with_context(|| format!("Failed to write {}", subgid_path.display()))?;

    Ok(())
}

/// Reconcile the on-disk databases with the declared config.
///
/// For each configured user:
///   - explicit sub*id ranges are written verbatim;
///   - if `auto` is set and no auto-style range exists yet, allocate one that
///     does not overlap any other owner's ranges.
///
/// Existing entries for owners not in the config are kept so that ranges are
/// never reassigned.
fn apply(config: &Config, subuid: &mut SubIdDb, subgid: &mut SubIdDb) -> Result<()> {
    let configured: BTreeSet<&str> = config.users.iter().map(|u| u.name.as_str()).collect();

    for name in subuid
        .names()
        .chain(subgid.names())
        .collect::<BTreeSet<_>>()
    {
        if !configured.contains(name) {
            log::info!("Keeping existing sub*id ranges for unconfigured owner {name}");
        }
    }

    // First pass: lay down all explicit ranges and carry over existing auto
    // ranges, so the second pass can allocate new auto ranges against the
    // complete picture.
    let mut needs_auto: Vec<&str> = Vec::new();
    for user in &config.users {
        let mut uranges: Vec<Range> = user
            .sub_uid_ranges
            .iter()
            .map(|r| Range {
                start: r.start,
                count: r.count,
            })
            .collect();
        let mut granges: Vec<Range> = user
            .sub_gid_ranges
            .iter()
            .map(|r| Range {
                start: r.start,
                count: r.count,
            })
            .collect();

        if user.auto {
            if let Some(existing) = subuid
                .auto_range(&user.name, config.auto_count)
                .or_else(|| subgid.auto_range(&user.name, config.auto_count))
            {
                uranges.push(existing);
                granges.push(existing);
            } else {
                needs_auto.push(&user.name);
            }
        }

        subuid.set(&user.name, uranges);
        subgid.set(&user.name, granges);
    }

    // Second pass: allocate fresh auto ranges in deterministic (config) order.
    for name in needs_auto {
        let mut occupied = subuid.occupied();
        occupied.extend(subgid.occupied());
        occupied.sort_by_key(|(_, r)| r.start);

        let range = allocate(config.auto_base, config.auto_count, &occupied)
            .with_context(|| format!("Failed to allocate auto sub*id range for {name}"))?;
        log::info!(
            "Allocated auto sub*id range {}:{}:{}",
            name,
            range.start,
            range.count
        );

        let mut u = subuid.ranges(name).to_vec();
        u.push(range);
        subuid.set(name, u);

        let mut g = subgid.ranges(name).to_vec();
        g.push(range);
        subgid.set(name, g);
    }

    Ok(())
}

/// Report overlapping ranges across owners.
///
/// The auto-allocator never produces overlaps, so any overlap originates from
/// explicit configuration (also warned about at eval time) or pre-existing
/// on-disk state.
///
/// In the default mode this only warns: refusing to write the file would
/// leave /etc/sub*id absent or stale, which is strictly worse than an
/// overlap. With --strict the overlap becomes a hard error so it never
/// reaches disk; the previous file contents are left untouched.
fn check_overlap(what: &str, db: &SubIdDb, strict: bool) -> Result<()> {
    let occupied = db.occupied();
    if let Some(((a, ar), (b, br))) = find_overlap(&occupied) {
        let msg = format!(
            "{what}: range {}:{}:{} overlaps {}:{}:{}; \
             one user's unprivileged containers may access the other's",
            a, ar.start, ar.count, b, br.start, br.count
        );
        if strict {
            bail!("{msg}");
        }
        log::warn!("{msg}");
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn cfg(json: serde_json::Value) -> Config {
        serde_json::from_value(json).unwrap()
    }

    #[test]
    fn explicit_and_auto() {
        let config = cfg(serde_json::json!({
            "users": [
                { "name": "explicit",
                  "subUidRanges": [{ "start": 300000, "count": 65536 }],
                  "subGidRanges": [{ "start": 300000, "count": 65536 }] },
                { "name": "auto", "auto": true },
            ],
        }));
        let mut subuid = SubIdDb::default();
        let mut subgid = SubIdDb::default();
        apply(&config, &mut subuid, &mut subgid).unwrap();

        assert_eq!(
            subuid.ranges("explicit"),
            &[Range {
                start: 300000,
                count: 65536
            }]
        );
        // auto starts at 100000 (default base), explicit at 300000 -> no clash.
        assert_eq!(
            subuid.ranges("auto"),
            &[Range {
                start: 100000,
                count: 65536
            }]
        );

        assert!(find_overlap(&subuid.occupied()).is_none());
    }

    #[test]
    fn existing_auto_preserved() {
        let config = cfg(serde_json::json!({
            "users": [{ "name": "alice", "auto": true }],
        }));
        let mut subuid = SubIdDb::from_str("alice:424242:65536\n").unwrap();
        let mut subgid = SubIdDb::from_str("alice:424242:65536\n").unwrap();
        apply(&config, &mut subuid, &mut subgid).unwrap();
        assert_eq!(
            subuid.ranges("alice"),
            &[Range {
                start: 424242,
                count: 65536
            }]
        );
    }

    #[test]
    fn auto_avoids_incus_root_range() {
        let config = cfg(serde_json::json!({
            "autoBase": 100000,
            "users": [
                { "name": "root",
                  "subUidRanges": [{ "start": 100000, "count": 1000000000 }],
                  "subGidRanges": [{ "start": 100000, "count": 1000000000 }] },
                { "name": "alice", "auto": true },
            ],
        }));
        let mut subuid = SubIdDb::default();
        let mut subgid = SubIdDb::default();
        apply(&config, &mut subuid, &mut subgid).unwrap();
        assert_eq!(subuid.ranges("alice")[0].start, 1_000_100_000);
        assert!(find_overlap(&subuid.occupied()).is_none());
    }

    #[test]
    fn unconfigured_owner_kept() {
        let config = cfg(serde_json::json!({
            "users": [{ "name": "alice", "auto": true }],
        }));
        let mut subuid = SubIdDb::from_str("bob:500000:65536\n").unwrap();
        let mut subgid = SubIdDb::from_str("bob:500000:65536\n").unwrap();
        apply(&config, &mut subuid, &mut subgid).unwrap();
        assert_eq!(
            subuid.ranges("bob"),
            &[Range {
                start: 500000,
                count: 65536
            }]
        );
    }

    #[test]
    fn idempotent() {
        let config = cfg(serde_json::json!({
            "users": [
                { "name": "a", "auto": true },
                { "name": "b", "auto": true },
                { "name": "e",
                  "subUidRanges": [{ "start": 700000, "count": 65536 }],
                  "subGidRanges": [{ "start": 700000, "count": 65536 }] },
            ],
        }));
        let mut subuid = SubIdDb::default();
        let mut subgid = SubIdDb::default();
        apply(&config, &mut subuid, &mut subgid).unwrap();
        let before = subuid.to_buffer();
        apply(&config, &mut subuid, &mut subgid).unwrap();
        assert_eq!(subuid.to_buffer(), before);
    }

    #[test]
    fn explicit_overlap_detected() {
        let config = cfg(serde_json::json!({
            "users": [
                { "name": "a", "subUidRanges": [{ "start": 100000, "count": 65536 }] },
                { "name": "b", "subUidRanges": [{ "start": 100100, "count": 65536 }] },
            ],
        }));
        let mut subuid = SubIdDb::default();
        let mut subgid = SubIdDb::default();
        apply(&config, &mut subuid, &mut subgid).unwrap();
        // Overlap is detected but does not prevent writing the file.
        assert!(find_overlap(&subuid.occupied()).is_some());
    }
}
