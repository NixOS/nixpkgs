{
  lib,
  runCommand,
  python3,
}:

{
  name,
  dependencies,
  dependencySources,
  pubspecFile,
}:

let
  packages = lib.genAttrs dependencies (
    dependency:
    let
      src = dependencySources.${dependency};
    in
    {
      inherit src;
      inherit (src) packageRoot;
    }
  );
in
(runCommand ((if name != null then "${name}-" else "") + "package-graph.json") {
  inherit packages pubspecFile;

  nativeBuildInputs = [ (python3.withPackages (ps: with ps; [ pyyaml ])) ];

  __structuredAttrs = true;
})
  ''
    python3 ${./generator.py} > $out
  ''
