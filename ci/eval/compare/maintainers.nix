{
  lib,
}:
# Almost directly vendored from https://github.com/NixOS/ofborg/blob/5a4e743f192fb151915fcbe8789922fa401ecf48/ofborg/src/maintainers.nix
{
  changedattrs,
  changedpathsjson,
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

  enrichedAttrs = builtins.map (name: {
    path = lib.splitString "." name;
    name = name;
  }) changedattrs;

  validPackageAttributes = builtins.filter (
    pkg:
    if (lib.attrsets.hasAttrByPath pkg.path pkgs) then
      (
        let
          value = lib.attrsets.attrByPath pkg.path null pkgs;
        in
        if (builtins.tryEval value).success then
          if value != null then true else builtins.trace "${pkg.name} exists but is null" false
        else
          builtins.trace "Failed to access ${pkg.name} even though it exists" false
      )
    else
      builtins.trace "Failed to locate ${pkg.name}." false
  ) enrichedAttrs;

  attrsWithPackages = builtins.map (
    pkg: pkg // { package = lib.attrsets.attrByPath pkg.path null pkgs; }
  ) validPackageAttributes;

  attrsWithMaintainers = builtins.map (
    pkg:
    let
      meta = pkg.package.meta or { };
    in
    pkg
    // {
      # TODO: Refactor this so we can ping entire teams instead of the individual members.
      # Note that this will require keeping track of GH team IDs in "maintainers/teams.nix".
      maintainers = meta.maintainers or [ ];
    }
  ) attrsWithPackages;

  relevantFilenames =
    drv:
    (lib.lists.unique (
      builtins.map (pos: lib.strings.removePrefix (toString ../..) pos.file) (
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

  attrsWithFilenames = builtins.map (
    pkg: pkg // { filenames = relevantFilenames pkg.package; }
  ) attrsWithMaintainers;

  attrsWithModifiedFiles = builtins.filter (pkg: anyMatchingFiles pkg.filenames) attrsWithFilenames;

  listToPing = lib.concatMap (
    pkg:
    builtins.map (maintainer: {
      id = maintainer.githubId;
      inherit (maintainer) github;
      packageName = pkg.name;
      dueToFiles = pkg.filenames;
    }) pkg.maintainers
  ) attrsWithModifiedFiles;

  byMaintainer = lib.groupBy (ping: toString ping.${if byName then "github" else "id"}) listToPing;

  packagesPerMaintainer = lib.attrsets.mapAttrs (
    maintainer: packages: builtins.map (pkg: pkg.packageName) packages
  ) byMaintainer;
in
packagesPerMaintainer
