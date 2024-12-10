{ lib, ... }:
rec {
  # Borrowed from https://github.com/NixOS/nixpkgs/pull/355616
  uniqueStrings = list: builtins.attrNames (builtins.groupBy lib.id list);

  _processSystemPath =
    packageSystemPath:
    let
      # python312Packages.torch.aarch64-linux -> ["python312Packages" "torch" "aarch64-linux"]
      # splittedPath = lib.splitString "." attrName;
      splittedPath = lib.splitString "." packageSystemPath;

      # ["python312Packages" "torch" "aarch64-linux"] -> ["python312Packages" "torch"]
      packagePath = lib.sublist 0 (lib.length splittedPath - 1) splittedPath;
    in
    {
      # "python312Packages.torch"
      name = lib.concatStringsSep "." packagePath;

      # "aarch64-linux"
      system = lib.last splittedPath;
    };

  # Turns
  # [
  #   "hello.aarch64-linux"
  #   "hello.x86_64-linux"
  #   "hello.aarch64-darwin"
  #   "hello.x86_64-darwin"
  #   "bye.x86_64-darwin"
  #   "bye.aarch64-darwin"
  # ]
  #
  # into
  #
  # [
  #   "hello"
  #   "bye"
  # ]
  extractPackageNames =
    packageSystemPaths:
    builtins.attrNames (
      builtins.removeAttrs (builtins.groupBy (
        packageSystemPath: (_processSystemPath packageSystemPath).name
      ) packageSystemPaths) [ "" ]
    );

  # Computes a diff between two attrs
  # {
  #   added: [ <keys only in the second object> ],
  #   removed: [ <keys only in the first object> ],
  #   changed: [ <keys with different values between the two objects> ],
  # }
  #
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

  # Turns
  # [
  #   "hello.aarch64-linux"
  #   "hello.x86_64-linux"
  #   "hello.aarch64-darwin"
  #   "hello.x86_64-darwin"
  #   "bye.x86_64-darwin"
  #   "bye.aarch64-darwin"
  # ]
  #
  # into
  #
  # {
  #   linux = [
  #     "hello"
  #   ];
  #   darwin = [
  #     "hello"
  #     "bye"
  #   ];
  # }
  groupByKernel =
    systemPaths:
    let
      systemPaths' = builtins.map _processSystemPath systemPaths;

      filterKernel =
        kernel:
        builtins.attrNames (
          builtins.groupBy (systemPath: systemPath.name) (
            builtins.filter (systemPath: lib.hasSuffix kernel systemPath.system) systemPaths'
          )
        );
    in
    lib.genAttrs [ "linux" "darwin" ] filterKernel;

  getLabels = lib.mapAttrs (
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
