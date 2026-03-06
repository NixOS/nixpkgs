# Figure out which maintainers (users/teams) are relevant for a PR:
# - All maintainers that can be linked directly to changedFiles
# - Maintainers of affectedAttrPaths if a file directly related to the attribute is in changedFiles
#
# Files and attributes are linked in various ways:
# - pkgs/by-name/<attr>/* is linked to pkgs.<attr>
# - The file position of various attributes of pkgs.<attr>
# - Explicitly specified file positions in derivations
#
# Test with
#   nix-instantiate --eval --strict --json test.nix -A result | jq
#
# Empty list as an output means success
{
  # Files that were changed
  # Type: ListOf (Nixpkgs-root-relative path)
  changedFiles,
  # Attributes whose value was affected by the change
  # Type: ListOf (ListOf String)
  affectedAttrPaths,

  pkgs ? import ../../.. {
    system = "x86_64-linux";
    # We should never try to ping maintainers through package aliases, this can only lead to errors.
    # One example case is, where an attribute is a throw alias, but then re-introduced in a PR.
    # This would trigger the throw. By disabling aliases, we can fallback gracefully below.
    config.allowAliases = false;
    overlays = [ ];
  },
  lib,
}:
let
  nixpkgsRoot = toString ../../.. + "/";
  stripNixpkgsRootFromKeys = lib.mapAttrs' (
    file: value: lib.nameValuePair (lib.removePrefix nixpkgsRoot file) value
  );

  moduleMeta = (pkgs.nixos { }).config.meta;

  # Currently just nixos module maintainers, but in the future we can use this for code owners too
  fileUsers = stripNixpkgsRootFromKeys moduleMeta.maintainers;
  fileTeams = stripNixpkgsRootFromKeys moduleMeta.teams;

  anyMatchingFile = filename: lib.any (lib.hasPrefix filename) changedFiles;

  anyMatchingFiles = files: lib.any anyMatchingFile files;

  relevantFilenames =
    drv:
    (lib.unique (
      map (pos: lib.removePrefix nixpkgsRoot pos.file) (
        lib.filter (x: x != null) [
          (drv.meta.maintainersPosition or null)
          (drv.meta.teamsPosition or null)
          (lib.unsafeGetAttrPos "src" drv)
          (lib.unsafeGetAttrPos "pname" drv)
          (lib.unsafeGetAttrPos "version" drv)
        ]
        ++ lib.optionals (drv ? meta.position) [
          # Use ".meta.position" for cases when most of the package is
          # defined in a "common" section and the only place where
          # reference to the file with a derivation the "pos"
          # attribute.
          #
          # ".meta.position" has the following form:
          #   "pkgs/tools/package-management/nix/default.nix:155"
          # We transform it to the following:
          #   { file = "pkgs/tools/package-management/nix/default.nix"; }
          { file = lib.head (lib.splitString ":" drv.meta.position); }
        ]
      )
    ));

  relevantAffectedAttrPaths = lib.filter (
    attrPath:
    # Some packages might be reported as changed on a different platform, but
    # not even have an attribute on the platform the maintainers are requested on.
    # Fallback to `null` for these to filter them out
    let
      package = lib.attrByPath attrPath null pkgs;
    in
    package != null && anyMatchingFiles (relevantFilenames package)
  ) affectedAttrPaths;

  # Extract attributes that changed from by-name paths.
  # This allows pinging reviewers for pure refactors.
  changedByNameAttrPaths = lib.pipe changedFiles [
    (lib.filter (changed: lib.hasPrefix "pkgs/by-name/" changed))
    (map (lib.splitString "/"))
    # Filters out e.g. pkgs/by-name/README.md
    (lib.filter (path: lib.length path > 3))
    (map (path: lib.elemAt path 3))
    (map lib.singleton)
  ];

  # An attribute can appear in affected *and* touched
  attrPathsToGetMaintainersFor = lib.unique (relevantAffectedAttrPaths ++ changedByNameAttrPaths);

  attrPathEntities = lib.concatMap (
    attrPath:
    let
      package = lib.getAttrFromPath attrPath pkgs;
    in
    # meta.maintainers also contains all individual team members.
    # We only want to ping individuals if they're added individually as maintainers, not via teams.
    userPings { inherit attrPath; } (package.meta.nonTeamMaintainers or [ ])
    ++ lib.concatMap (teamPings { inherit attrPath; }) (package.meta.teams or [ ])
  ) attrPathsToGetMaintainersFor;

  changedFileEntities = lib.concatMap (
    file:
    userPings { inherit file; } (fileUsers.${file} or [ ])
    ++ lib.concatMap (teamPings { inherit file; }) (fileTeams.${file} or [ ])
  ) changedFiles;

  userPings =
    context:
    map (maintainer: {
      type = "user";
      userId = maintainer.githubId;
      inherit context;
    });

  teamPings =
    context: team:
    if team ? githubId then
      [
        {
          type = "team";
          teamId = team.githubId;
          inherit context;
        }
      ]
    else
      userPings context team.members;

  byType = lib.groupBy (ping: ping.type) (attrPathEntities ++ changedFileEntities);

  byUser = lib.pipe (byType.user or [ ]) [
    (lib.groupBy (ping: toString ping.userId))
    (lib.mapAttrs (_user: lib.map (pkg: pkg.context)))
  ];
  byTeam = lib.pipe (byType.team or [ ]) [
    (lib.groupBy (ping: toString ping.teamId))
    (lib.mapAttrs (_team: lib.map (pkg: pkg.context)))
  ];
in
{
  users = byUser;
  teams = byTeam;
  packages = attrPathsToGetMaintainersFor;
}
