{ lib, config }:
rec {
  resolveOsUser = backup: snapshot: if snapshot.user != null then snapshot.user else backup.user;

  resolveSourceUser =
    backup: snapshot:
    if snapshot.source.user != null then snapshot.source.user else resolveOsUser backup snapshot;

  resolveSourceHost =
    snapshot:
    if snapshot.source.host != null then snapshot.source.host else config.networking.hostName;

  resolveSourcePath =
    snapshot:
    if snapshot.source.path != null then snapshot.source.path else snapshot.path;

  # The triple kopia uses for snapshot source identifiers (and matching policy
  # targets). Passed via `kopia snapshot create --override-source=...` so the
  # snapshot registers under the resolved source regardless of OS user, system
  # hostname, or mount point.
  snapshotTarget =
    backup: snapshot:
    "${resolveSourceUser backup snapshot}@${resolveSourceHost snapshot}:${resolveSourcePath snapshot}";
}
