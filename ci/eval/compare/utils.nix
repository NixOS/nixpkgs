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
        packagePath = [ "hello" ];
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
        # [ "python312Packages" "numpy" ]
        inherit packagePath;

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
        { name = "hello"; platform = "aarch64-linux"; packagePath = [ "hello" ]; }
        { name = "hello"; platform = "x86_64-linux"; packagePath = [ "hello" ]; }
        { name = "hello"; platform = "aarch64-darwin"; packagePath = [ "hello" ]; }
        { name = "hello"; platform = "x86_64-darwin"; packagePath = [ "hello" ]; }
        { name = "bye"; platform = "aarch64-darwin"; packagePath = [ "hello" ]; }
        { name = "bye"; platform = "x86_64-darwin"; packagePath = [ "hello" ]; }
      ]
  */
  convertToPackagePlatformAttrs =
    packagePlatformPaths:
    builtins.filter (x: x != null) (map convertToPackagePlatformAttr packagePlatformPaths);

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
    uniqueStrings (map (p: p.name) packagePlatformAttrs);

  /*
    Group a list of `packagePlatformAttr`s by platforms

    Turns
      [
        { name = "hello"; platform = "aarch64-linux"; ... }
        { name = "hello"; platform = "x86_64-linux"; ... }
        { name = "hello"; platform = "aarch64-darwin"; ... }
        { name = "hello"; platform = "x86_64-darwin"; ... }
        { name = "bye"; platform = "aarch64-darwin"; ... }
        { name = "bye"; platform = "x86_64-darwin"; ... }
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
  #   { name = "hello"; platform = "aarch64-linux"; ... }
  #   { name = "hello"; platform = "x86_64-linux"; ... }
  #   { name = "hello"; platform = "aarch64-darwin"; ... }
  #   { name = "hello"; platform = "x86_64-darwin"; ... }
  #   { name = "bye"; platform = "aarch64-darwin"; ... }
  #   { name = "bye"; platform = "x86_64-darwin"; ... }
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
    Maps an attrs of `kernel - rebuild counts` mappings to an attrs of labels

    Turns
      {
        linux = 56;
        darwin = 1;
      }
    into
      {
        "10.rebuild-darwin: 1" = true;
        "10.rebuild-darwin: 1-10" = true;
        "10.rebuild-darwin: 11-100" = false;
        # [...]
        "10.rebuild-darwin: 1" = false;
        "10.rebuild-darwin: 1-10" = false;
        "10.rebuild-linux: 11-100" = true;
        # [...]
      }
  */
  getLabels =
    rebuildCountByKernel:
    lib.mergeAttrsList (
      lib.mapAttrsToList (
        kernel: rebuildCount:
        let
          range = from: to: from <= rebuildCount && (to == null || rebuildCount <= to);
        in
        lib.mapAttrs' (number: lib.nameValuePair "10.rebuild-${kernel}: ${number}") {
          "0" = range 0 0;
          "1" = range 1 1;
          "1-10" = range 1 10;
          "11-100" = range 11 100;
          "101-500" = range 101 500;
          "501-1000" = range 501 1000;
          "501+" = range 501 null;
          "1001-2500" = range 1001 2500;
          "2501-5000" = range 2501 5000;
          "5001+" = range 5001 null;
        }
      ) rebuildCountByKernel
    );
}
