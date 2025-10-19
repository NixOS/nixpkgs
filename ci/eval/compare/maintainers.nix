{
  lib,
}:
{
  changedattrs,
  changedpathsjson,
  removedattrs,
}:
let
  pkgs = import ../../.. { system = "x86_64-linux"; };

  changedpaths = lib.importJSON changedpathsjson;

  # Extract attributes that changed from by-name paths.
  # This allows pinging reviewers for pure refactors.
  touchedattrs = lib.pipe changedpaths [
    (lib.filter (changed: lib.hasPrefix "pkgs/by-name/" changed))
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
        # TODO: Refactor this so we can ping entire teams instead of the individual members.
        # Note that this will require keeping track of GH team IDs in "maintainers/teams.nix".
        maintainers = package.meta.maintainers or [ ];
      }
    ))
    # No need to match up packages without maintainers with their files.
    # This also filters out attributes where `packge = null`, which is the
    # case for libintl, for example.
    (lib.filter (pkg: pkg.maintainers != [ ]))
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

          # Use ".meta.position" for cases when most of the package is
          # defined in a "common" section and the only place where
          # reference to the file with a derivation the "pos"
          # attribute.
          #
          # ".meta.position" has the following form:
          #   "pkgs/tools/package-management/nix/default.nix:155"
          # We transform it to the following:
          #   { file = "pkgs/tools/package-management/nix/default.nix"; }
          { file = lib.head (lib.splitString ":" (drv.meta.position or "")); }
        ]
      )
    ));

  attrsWithFilenames = map (
    pkg: pkg // { filenames = pkg.filenames ++ relevantFilenames pkg.package; }
  ) attrsWithMaintainers;

  attrsWithModifiedFiles = lib.filter (pkg: anyMatchingFiles pkg.filenames) attrsWithFilenames;

  listToPing = lib.concatMap (
    pkg:
    map (maintainer: {
      id = maintainer.githubId;
      inherit (maintainer) github;
      packageName = pkg.name;
      dueToFiles = pkg.filenames;
    }) pkg.maintainers
  ) attrsWithModifiedFiles;

  byMaintainer = lib.groupBy (ping: toString ping.id) listToPing;

  packagesPerMaintainer = lib.mapAttrs (
    maintainer: packages: map (pkg: pkg.packageName) packages
  ) byMaintainer;
in
packagesPerMaintainer
