{
  lib,
  jq,
  runCommand,
  writeText,
  ...
}:
{ beforeResultDir, afterResultDir }:
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
    uniqueStrings
    ;

  getAttrs = dir: builtins.fromJSON (builtins.readFile "${dir}/outpaths.json");
  beforeAttrs = getAttrs beforeResultDir;
  afterAttrs = getAttrs afterResultDir;

  # Attrs
  # - keys: "added", "changed" and "removed"
  # - values: lists of `packagePlatformPath`s
  diffAttrs = diff beforeAttrs afterAttrs;

  changed-paths =
    let
      rebuilds = uniqueStrings (diffAttrs.added ++ diffAttrs.changed);
      rebuildsPackagePlatformAttrs = convertToPackagePlatformAttrs rebuilds;

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
        labels = getLabels rebuildCountByKernel;
      }
    );
in
runCommand "compare"
  {
    nativeBuildInputs = [ jq ];
  }
  ''
    mkdir $out

    cp ${changed-paths} $out/changed-paths.json

    jq -r -f ${./generate-step-summary.jq} < ${changed-paths} > $out/step-summary.md
    # TODO: Compare eval stats
  ''
