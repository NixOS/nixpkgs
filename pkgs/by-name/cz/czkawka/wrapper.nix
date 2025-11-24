{
  lib,
  czkawka,
  makeWrapper,
  symlinkJoin,
  # configurable options
  extraPackages ? [ ],
}:

symlinkJoin {
  name = "czkawka-wrapped-${czkawka.version}";
  inherit (czkawka) pname version outputs;

  nativeBuildInputs = [ makeWrapper ];

  paths = [ czkawka ];

  postBuild = ''
    ${lib.concatMapStringsSep "\n" (
      output: "ln --symbolic --no-target-directory ${czkawka.${output}} \$${output}"
    ) (lib.remove "out" czkawka.outputs)}

    pushd $out/bin
    for f in *; do
      rm -v $f
      makeWrapper ${lib.getBin czkawka}/bin/$f $out/bin/$f \
        --prefix PATH ":" "${lib.makeBinPath extraPackages}"
    done
    popd
  '';

  meta = czkawka.meta;
}
