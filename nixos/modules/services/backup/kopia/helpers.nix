{ lib, config }:
rec {
  resolveOsUser = backup: snapshot: if snapshot.user != null then snapshot.user else backup.user;

  resolveSourceUser =
    backup: snapshot:
    if snapshot.source.user != null then snapshot.source.user else resolveOsUser backup snapshot;

  resolveSourceHost =
    snapshot: if snapshot.source.host != null then snapshot.source.host else config.networking.hostName;

  resolveSourcePath =
    snapshot: if snapshot.source.path != null then snapshot.source.path else snapshot.path;

  # The triple kopia uses for snapshot source identifiers (and matching policy
  # targets). Passed via `kopia snapshot create --override-source=...` so the
  # snapshot registers under the resolved source regardless of OS user, system
  # hostname, or mount point.
  snapshotTarget =
    backup: snapshot:
    "${resolveSourceUser backup snapshot}@${resolveSourceHost snapshot}:${resolveSourcePath snapshot}";

  # Policies that will be passed to `kopia policy import`: the union of the
  # per-snapshot `policy` sugar and the explicit `policies.entries`, with the
  # latter taking precedence.
  effectivePolicies =
    backup:
    let
      snapshotPolicyEntries = lib.foldl' lib.mergeAttrs { } (
        lib.mapAttrsToList (
          _: snapshot:
          lib.optionalAttrs (snapshot.policy != { }) {
            ${snapshotTarget backup snapshot} = snapshot.policy;
          }
        ) backup.snapshots
      );
    in
    lib.recursiveUpdate snapshotPolicyEntries backup.policies.entries;

  # Whether the backup needs a policy-import unit. Declarative mode needs one
  # even with no declared policies, so that it can delete all existing ones.
  hasPolicyService = backup: effectivePolicies backup != { } || backup.policies.declarative;
}
