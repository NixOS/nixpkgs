{
  lib,
  jq,
  runCommand,
  writeText,
  supportedSystems,
  ...
}:
{ beforeResultDir, afterResultDir }:
let
  inherit (import ./utils.nix { inherit lib; })
    diff
    groupByKernel
    extractPackageNames
    getLabels
    uniqueStrings
    ;

  getAttrs = dir: builtins.fromJSON (builtins.readFile "${dir}/outpaths.json");
  beforeAttrs = getAttrs beforeResultDir;
  afterAttrs = getAttrs afterResultDir;

  diffAttrs = diff beforeAttrs afterAttrs;

  changed-paths =
    let
      rebuilds = uniqueStrings (diffAttrs.added ++ diffAttrs.changed);

      rebuildsByKernel = groupByKernel rebuilds;
      rebuildCountByKernel = lib.mapAttrs (
        kernel: kernelRebuilds: lib.length kernelRebuilds
      ) rebuildsByKernel;
    in
    writeText "changed-paths.json" (
      builtins.toJSON {
        attrdiff = lib.mapAttrs (_: v: extractPackageNames v) diffAttrs;
        inherit rebuildsByKernel rebuildCountByKernel;
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
