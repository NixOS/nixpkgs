{
  lib,
  changedattrs,
  changedpathsjson,
  removedattrs,
}:
let
  pkgs = import ../../.. {
    system = "x86_64-linux";
    # We should never try to ping maintainers through package aliases, this can only lead to errors.
    # One example case is, where an attribute is a throw alias, but then re-introduced in a PR.
    # This would trigger the throw. By disabling aliases, we can fallback gracefully below.
    config.allowAliases = false;
  };

  nixpkgsRoot = toString ../../.. + "/";
  stripNixpkgsRootFromKeys = lib.mapAttrs' (
    file: value: lib.nameValuePair (lib.removePrefix nixpkgsRoot file) value
  );

  moduleMeta = (pkgs.nixos { }).config.meta;

  # Currently just nixos module maintainers, but in the future we can use this for code owners too
  fileMaintainers = stripNixpkgsRootFromKeys moduleMeta.maintainers;
  fileTeams = stripNixpkgsRootFromKeys moduleMeta.teams;

  changedpaths = lib.importJSON changedpathsjson;

  # Extract attributes that changed from by-name paths.
  # This allows pinging reviewers for pure refactors.
  touchedattrs = lib.pipe changedpaths [
    (lib.filter (changed: lib.hasPrefix "pkgs/by-name/" changed && changed != "pkgs/by-name/README.md"))
    (map (lib.splitString "/"))
    (map (path: lib.elemAt path 3))
    lib.unique
  ];

  anyMatchingFile = filename: lib.any (lib.hasPrefix filename) changedpaths;

  anyMatchingFiles = files: lib.any anyMatchingFile files;

  sharded = name: "${lib.substring 0 2 name}/${name}";

  attrsWithMaintainers = lib.pipe (changedattrs ++ removedattrs ++ touchedattrs) [
    # An attribute can appear in changed/removed *and* touched
    lib.unique
    (map (
      name:
      let
        path = lib.splitString "." name;
        # Some packages might be reported as changed on a different platform, but
        # not even have an attribute on the platform the maintainers are requested on.
        # Fallback to `null` for these to filter them out below.
        package = lib.attrByPath path null pkgs;
      in
      {
        inherit name package;
        # Adds all files in by-name to each package, no matter whether they are discoverable
        # via meta attributes below. For example, this allows pinging maintainers for
        # updates to .json files.
        # TODO: Support by-name package sets.
        filenames = lib.optional (lib.length path == 1) "pkgs/by-name/${sharded (lib.head path)}/";
        # meta.maintainers also contains all individual team members.
        # We only want to ping individuals if they're added individually as maintainers, not via teams.
        users = package.meta.nonTeamMaintainers or [ ];
        teams = package.meta.teams or [ ];
      }
    ))
    # No need to match up packages without maintainers with their files.
    # This also filters out attributes where `package = null`, which is the
    # case for libintl, for example.
    (lib.filter (pkg: pkg.users != [ ] || pkg.teams != [ ]))
  ];

  relevantFilenames =
    drv:
    (lib.unique (
      map (pos: lib.removePrefix "${toString ../../..}/" pos.file) (
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

  attrsWithFilenames = map (
    pkg: pkg // { filenames = pkg.filenames ++ relevantFilenames pkg.package; }
  ) attrsWithMaintainers;

  attrsWithModifiedFiles = lib.filter (pkg: anyMatchingFiles pkg.filenames) attrsWithFilenames;

  userPings =
    context:
    map (maintainer: {
      type = "user";
      userId = maintainer.githubId;
      inherit context;
    });

  teamPings =
    context: team:
    if team ? github then
      [
        {
          type = "team";
          teamId = team.githubId;
          inherit context;
        }
      ]
    else
      userPings context team.members;

  maintainersToPing =
    lib.concatMap (
      pkg:
      userPings { attr = pkg.name; } pkg.users ++ lib.concatMap (teamPings { pkg = pkg.name; }) pkg.teams
    ) attrsWithModifiedFiles
    ++ lib.concatMap (
      path:
      userPings { file = path; } (fileMaintainers.${path} or [ ])
      ++ lib.concatMap (teamPings { file = path; }) (fileTeams.${path} or [ ])
    ) changedpaths;

  byType = lib.groupBy (ping: ping.type) maintainersToPing;

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
  packages = lib.catAttrs "name" attrsWithModifiedFiles;
}
