# Almost directly vendored from https://github.com/NixOS/ofborg/blob/5a4e743f192fb151915fcbe8789922fa401ecf48/ofborg/src/maintainers.nix
{ changedattrs, changedpathsjson }:
let
  pkgs = import ../../.. {
    system = "x86_64-linux";
    config = { };
    overlays = [ ];
  };
  inherit (pkgs) lib;

  changedpaths = builtins.fromJSON (builtins.readFile changedpathsjson);

  anyMatchingFile =
    filename:
    let
      matching = builtins.filter (changed: lib.strings.hasSuffix changed filename) changedpaths;
    in
    (builtins.length matching) > 0;

  anyMatchingFiles = files: (builtins.length (builtins.filter anyMatchingFile files)) > 0;

  enrichedAttrs = builtins.map (path: {
    path = path;
    name = builtins.concatStringsSep "." path;
  }) changedattrs;

  validPackageAttributes = builtins.filter (
    pkg:
    if (lib.attrsets.hasAttrByPath pkg.path pkgs) then
      (
        if (builtins.tryEval (lib.attrsets.attrByPath pkg.path null pkgs)).success then
          true
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
    pkg: pkg // { maintainers = (pkg.package.meta or { }).maintainers or [ ]; }
  ) attrsWithPackages;

  relevantFilenames =
    drv:
    (lib.lists.unique (
      builtins.map (pos: lib.strings.removePrefix (toString ../..) pos.file) (
        builtins.filter (x: x != null) [
          (builtins.unsafeGetAttrPos "maintainers" (drv.meta or { }))
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

  listToPing = lib.lists.flatten (
    builtins.map (
      pkg:
      builtins.map (maintainer: {
        id = maintainer.githubId;
        packageName = pkg.name;
        dueToFiles = pkg.filenames;
      }) pkg.maintainers
    ) attrsWithModifiedFiles
  );

  byMaintainer = lib.lists.foldr (
    ping: collector:
    collector
    // {
      "${toString ping.id}" = [
        { inherit (ping) packageName dueToFiles; }
      ] ++ (collector."${toString ping.id}" or [ ]);
    }
  ) { } listToPing;


  packagesPerMaintainer = lib.attrsets.mapAttrs (
    maintainer: packages: builtins.map (pkg: pkg.packageName) packages
  ) byMaintainer;
in
packagesPerMaintainer
