{ lib, ... }:
rec {
  # Borrowed from https://github.com/NixOS/nixpkgs/pull/355616
  uniqueStrings = list: builtins.attrNames (builtins.groupBy lib.id list);

  /*
    Converts a `packagePlatformPath` into a `packagePlatformAttr`

    Turns
      "hello.aarch64-linux"
    into
      {
        name = "hello";
        platform = "aarch64-linux";
      }
  */
  convertToPackagePlatformAttr =
    packagePlatformPath:
    let
      # python312Packages.numpy.aarch64-linux -> ["python312Packages" "numpy" "aarch64-linux"]
      splittedPath = lib.splitString "." packagePlatformPath;

      # ["python312Packages" "numpy" "aarch64-linux"] -> ["python312Packages" "numpy"]
      packagePath = lib.sublist 0 (lib.length splittedPath - 1) splittedPath;

      # "python312Packages.numpy"
      name = lib.concatStringsSep "." packagePath;
    in
    if name == "" then
      null
    else
      {
        # python312Packages.numpy
        inherit name;

        # "aarch64-linux"
        platform = lib.last splittedPath;
      };

  /*
    Converts a list of `packagePlatformPath`s into a list of `packagePlatformAttr`s

    Turns
      [
        "hello.aarch64-linux"
        "hello.x86_64-linux"
        "hello.aarch64-darwin"
        "hello.x86_64-darwin"
        "bye.x86_64-darwin"
        "bye.aarch64-darwin"
        "release-checks"  <- Will be dropped
      ]
    into
      [
        { name = "hello"; platform = "aarch64-linux"; }
        { name = "hello"; platform = "x86_64-linux"; }
        { name = "hello"; platform = "aarch64-darwin"; }
        { name = "hello"; platform = "x86_64-darwin"; }
        { name = "bye"; platform = "aarch64-darwin"; }
        { name = "bye"; platform = "x86_64-darwin"; }
      ]
  */
  convertToPackagePlatformAttrs =
    packagePlatformPaths:
    builtins.filter (x: x != null) (builtins.map convertToPackagePlatformAttr packagePlatformPaths);

  /*
    Converts a list of `packagePlatformPath`s directly to a list of (unique) package names

    Turns
      [
        "hello.aarch64-linux"
        "hello.x86_64-linux"
        "hello.aarch64-darwin"
        "hello.x86_64-darwin"
        "bye.x86_64-darwin"
        "bye.aarch64-darwin"
      ]
    into
      [
        "hello"
        "bye"
      ]
  */
  extractPackageNames =
    packagePlatformPaths:
    let
      packagePlatformAttrs = convertToPackagePlatformAttrs (uniqueStrings packagePlatformPaths);
    in
    uniqueStrings (builtins.map (p: p.name) packagePlatformAttrs);

  /*
    Computes the key difference between two attrs

    {
      added: [ <keys only in the second object> ],
      removed: [ <keys only in the first object> ],
      changed: [ <keys with different values between the two objects> ],
    }
  */
  diff =
    let
      filterKeys = cond: attrs: lib.attrNames (lib.filterAttrs cond attrs);
    in
    old: new: {
      added = filterKeys (n: _: !(old ? ${n})) new;
      removed = filterKeys (n: _: !(new ? ${n})) old;
      changed = filterKeys (
        n: v:
        # Filter out attributes that don't exist anymore
        (new ? ${n})

        # Filter out attributes that are the same as the new value
        && (v != (new.${n}))
      ) old;
    };

  /*
    Group a list of `packagePlatformAttr`s by platforms

    Turns
      [
        { name = "hello"; platform = "aarch64-linux"; }
        { name = "hello"; platform = "x86_64-linux"; }
        { name = "hello"; platform = "aarch64-darwin"; }
        { name = "hello"; platform = "x86_64-darwin"; }
        { name = "bye"; platform = "aarch64-darwin"; }
        { name = "bye"; platform = "x86_64-darwin"; }
      ]
    into
      {
        aarch64-linux = [ "hello" ];
        x86_64-linux = [ "hello" ];
        aarch64-darwin = [ "hello" "bye" ];
        x86_64-darwin = [ "hello" "bye" ];
      }
  */
  groupByPlatform =
    packagePlatformAttrs:
    let
      packagePlatformAttrsByPlatform = builtins.groupBy (p: p.platform) packagePlatformAttrs;
      extractPackageNames = map (p: p.name);
    in
    lib.mapAttrs (_: extractPackageNames) packagePlatformAttrsByPlatform;

  # Turns
  # [
  #   { name = "hello"; platform = "aarch64-linux"; }
  #   { name = "hello"; platform = "x86_64-linux"; }
  #   { name = "hello"; platform = "aarch64-darwin"; }
  #   { name = "hello"; platform = "x86_64-darwin"; }
  #   { name = "bye"; platform = "aarch64-darwin"; }
  #   { name = "bye"; platform = "x86_64-darwin"; }
  # ]
  #
  # into
  #
  # {
  #   linux = [ "hello" ];
  #   darwin = [ "hello" "bye" ];
  # }
  groupByKernel =
    packagePlatformAttrs:
    let
      filterKernel =
        kernel:
        builtins.attrNames (
          builtins.groupBy (p: p.name) (
            builtins.filter (p: lib.hasSuffix kernel p.platform) packagePlatformAttrs
          )
        );
    in
    lib.genAttrs [ "linux" "darwin" ] filterKernel;

  /*
    Maps an attrs of `kernel - rebuild counts` mappings to a list of labels

    Turns
      {
        linux = 56;
        darwin = 8;
      }
    into
      [
        "10.rebuild-darwin: 1-10"
        "10.rebuild-linux: 11-100"
      ]
  */
  getLabels = lib.mapAttrsToList (
    kernel: rebuildCount:
    let
      number =
        if rebuildCount == 0 then
          "0"
        else if rebuildCount <= 10 then
          "1-10"
        else if rebuildCount <= 100 then
          "11-100"
        else if rebuildCount <= 500 then
          "101-500"
        else if rebuildCount <= 1000 then
          "501-1000"
        else if rebuildCount <= 2500 then
          "1001-2500"
        else if rebuildCount <= 5000 then
          "2501-5000"
        else
          "5001+";

    in
    "10.rebuild-${kernel}: ${number}"
  );
}
