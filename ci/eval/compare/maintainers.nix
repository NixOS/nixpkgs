{
  lib,
}:
{
  changedattrs,
  changedpathsjson,
  removedattrs,
  byName ? false,
}:
let
  pkgs = import ../../.. {
    system = "x86_64-linux";
    config = { };
    overlays = [ ];
  };

  changedpaths = builtins.fromJSON (builtins.readFile changedpathsjson);

  anyMatchingFile =
    filename: builtins.any (changed: lib.strings.hasSuffix changed filename) changedpaths;

  anyMatchingFiles = files: builtins.any anyMatchingFile files;

  attrsWithMaintainers = lib.pipe (changedattrs ++ removedattrs) [
    (map (
      name:
      let
        # Some packages might be reported as changed on a different platform, but
        # not even have an attribute on the platform the maintainers are requested on.
        # Fallback to `null` for these to filter them out below.
        package = lib.attrByPath (lib.splitString "." name) null pkgs;
      in
      {
        inherit name package;
        # TODO: Refactor this so we can ping entire teams instead of the individual members.
        # Note that this will require keeping track of GH team IDs in "maintainers/teams.nix".
        maintainers = package.meta.maintainers or [ ];
      }
    ))
    # No need to match up packages without maintainers with their files.
    # This also filters out attributes where `packge = null`, which is the
    # case for libintl, for example.
    (builtins.filter (pkg: pkg.maintainers != [ ]))
  ];

  relevantFilenames =
    drv:
    (lib.lists.unique (
      map (pos: lib.strings.removePrefix (toString ../..) pos.file) (
        builtins.filter (x: x != null) [
          ((drv.meta or { }).maintainersPosition or null)
          ((drv.meta or { }).teamsPosition or null)
          (builtins.unsafeGetAttrPos "src" drv)
          # broken because name is always set by stdenv:
          #    # A hack to make `nix-env -qa` and `nix search` ignore broken packages.
          #    # TODO(@oxij): remove this assert when something like NixOS/nix#1771 gets merged into nix.
          #    name = assert validity.handled; name + lib.optionalString
          #(builtins.unsafeGetAttrPos "name" drv)
          (builtins.unsafeGetAttrPos "pname" drv)
          (builtins.unsafeGetAttrPos "version" drv)

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
    pkg: pkg // { filenames = relevantFilenames pkg.package; }
  ) attrsWithMaintainers;

  attrsWithModifiedFiles = builtins.filter (pkg: anyMatchingFiles pkg.filenames) attrsWithFilenames;

  listToPing = lib.concatMap (
    pkg:
    map (maintainer: {
      id = maintainer.githubId;
      inherit (maintainer) github;
      packageName = pkg.name;
      dueToFiles = pkg.filenames;
    }) pkg.maintainers
  ) attrsWithModifiedFiles;

  byMaintainer = lib.groupBy (ping: toString ping.${if byName then "github" else "id"}) listToPing;

  packagesPerMaintainer = lib.attrsets.mapAttrs (
    maintainer: packages: map (pkg: pkg.packageName) packages
  ) byMaintainer;
in
packagesPerMaintainer
