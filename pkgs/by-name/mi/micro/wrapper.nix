{
  lib,
  micro,
  makeWrapper,
  symlinkJoin,
  # configurable options
  extraPackages ? [ ],
}:

symlinkJoin {
  name = "micro-wrapped-${micro.version}";
  inherit (micro) pname version outputs;

  nativeBuildInputs = [ makeWrapper ];

  paths = [ micro ];

  postBuild = ''
    ${lib.concatMapStringsSep "\n" (
      output: "ln --verbose --symbolic --no-target-directory ${micro.${output}} \$${output}"
    ) (lib.remove "out" micro.outputs)}

    pushd $out/bin
    for f in *; do
      rm $f
      makeWrapper ${micro}/bin/$f $f \
        --prefix PATH ":" "${lib.makeBinPath extraPackages}"
    done
    popd
  '';

  meta = micro.meta;
}
