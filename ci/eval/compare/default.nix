{
  lib,
  jq,
  runCommand,
  writeText,
  python3,
  ...
}:
{
  beforeResultDir,
  afterResultDir,
  touchedFilesJson,
}:
let
  /*
    Derivation that computes which packages are affected (added, changed or removed) between two revisions of nixpkgs.
    Note: "platforms" are "x86_64-linux", "aarch64-darwin", ...

    ---
    Inputs:
    - beforeResultDir, afterResultDir: The evaluation result from before and after the change.
      They can be obtained by running `nix-build -A ci.eval.full` on both revisions.

    ---
    Outputs:
      - changed-paths.json: Various information about the changes:
        {
          attrdiff: {
            added: ["package1"],
            changed: ["package2", "package3"],
            removed: ["package4"],
          },
          labels: [
            "10.rebuild-darwin: 1-10",
            "10.rebuild-linux: 1-10"
          ],
          rebuildsByKernel: {
            darwin: ["package1", "package2"],
            linux: ["package1", "package2", "package3"]
          },
          rebuildCountByKernel: {
            darwin: 2,
            linux: 3,
          },
          rebuildsByPlatform: {
            aarch64-darwin: ["package1", "package2"],
            aarch64-linux: ["package1", "package2"],
            x86_64-linux: ["package1", "package2", "package3"],
            x86_64-darwin: ["package1"],
          },
        }
      - step-summary.md: A markdown render of the changes

    ---
    Implementation details:

    Helper functions can be found in ./utils.nix.
    Two main "types" are important:

    - `packagePlatformPath`: A string of the form "<PACKAGE_PATH>.<PLATFORM>"
      Example: "python312Packages.numpy.x86_64-linux"

    - `packagePlatformAttr`: An attrs representation of a packagePlatformPath:
      Example: { name = "python312Packages.numpy"; platform = "x86_64-linux"; }
  */
  inherit (import ./utils.nix { inherit lib; })
    diff
    groupByKernel
    convertToPackagePlatformAttrs
    groupByPlatform
    extractPackageNames
    getLabels
    ;

  getAttrs =
    dir:
    let
      raw = builtins.readFile "${dir}/outpaths.json";
      # The file contains Nix paths; we need to ignore them for evaluation purposes,
      # else there will be a "is not allowed to refer to a store path" error.
      data = builtins.unsafeDiscardStringContext raw;
    in
    builtins.fromJSON data;
  beforeAttrs = getAttrs beforeResultDir;
  afterAttrs = getAttrs afterResultDir;

  # Attrs
  # - keys: "added", "changed" and "removed"
  # - values: lists of `packagePlatformPath`s
  diffAttrs = diff beforeAttrs afterAttrs;

  rebuilds = diffAttrs.added ++ diffAttrs.changed;
  rebuildsPackagePlatformAttrs = convertToPackagePlatformAttrs rebuilds;

  changed-paths =
    let
      rebuildsByPlatform = groupByPlatform rebuildsPackagePlatformAttrs;
      rebuildsByKernel = groupByKernel rebuildsPackagePlatformAttrs;
      rebuildCountByKernel = lib.mapAttrs (
        kernel: kernelRebuilds: lib.length kernelRebuilds
      ) rebuildsByKernel;
    in
    writeText "changed-paths.json" (
      builtins.toJSON {
        attrdiff = lib.mapAttrs (_: extractPackageNames) diffAttrs;
        inherit
          rebuildsByPlatform
          rebuildsByKernel
          rebuildCountByKernel
          ;
        labels =
          (getLabels rebuildCountByKernel)
          # Adds "10.rebuild-*-stdenv" label if the "stdenv" attribute was changed
          ++ lib.mapAttrsToList (kernel: _: "10.rebuild-${kernel}-stdenv") (
            lib.filterAttrs (_: kernelRebuilds: kernelRebuilds ? "stdenv") rebuildsByKernel
          );
      }
    );

  maintainers = import ./maintainers.nix {
    changedattrs = lib.attrNames (lib.groupBy (a: a.name) rebuildsPackagePlatformAttrs);
    changedpathsjson = touchedFilesJson;
  };
in
runCommand "compare"
  {
    nativeBuildInputs = [
      jq
      python3
    ];
    maintainers = builtins.toJSON maintainers;
    passAsFile = [ "maintainers" ];
    env = {
      BEFORE_DIR = "${beforeResultDir}";
      AFTER_DIR = "${afterResultDir}";
    };
    # export BEFORE_DIR=${beforeResultDir}
    # export AFTER_DIR=${afterResultDir}
  }
  ''
    mkdir $out

    cp ${changed-paths} $out/changed-paths.json

    jq -r -f ${./generate-step-summary.jq} < ${changed-paths} > $out/step-summary.md

    python3 ${./cmp-stats.py} >> $out/step-summary.md

    # Check file size and truncate if necessary
    # See: https://github.com/NixOS/nixpkgs/pull/365366
    MAX_SIZE=1048576 # 1024 KB in bytes
    FILE_SIZE=$(wc -c < "$out/step-summary.md")

    if [ "$FILE_SIZE" -gt "$MAX_SIZE" ]; then
        echo "File exceeds 1024 KB. Truncating..." >&2
        truncate -s "$MAX_SIZE" "$out/step-summary.md"
    fi

    cp "$maintainersPath" "$out/maintainers.json"

    # TODO: Compare eval stats
  ''
