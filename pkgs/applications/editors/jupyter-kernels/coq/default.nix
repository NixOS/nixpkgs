{ lib
, stdenv
, callPackage
, runCommand
, makeWrapper
, coq
, imagemagick
, python3
}:

# Jupyter console:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel coq-kernel.definition'

# Jupyter console with packages:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel (coq-kernel.definitionWithPackages [coqPackages.bignums])'

# Jupyter notebook:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter.override { definitions.coq = coq-kernel.definition; }'

let
  python = python3.withPackages (ps: [ ps.traitlets ps.jupyter-core ps.ipykernel (callPackage ./kernel.nix {}) ]);

  logos = runCommand "coq-logos" { buildInputs = [ imagemagick ]; } ''
    mkdir -p $out
    convert ${coq.src}/ide/coqide/coq.png -resize 32x32 $out/logo-32x32.png
    convert ${coq.src}/ide/coqide/coq.png -resize 64x64 $out/logo-64x64.png
  '';

in

rec {
  launcher = runCommand "coq-kernel-launcher" {
    nativeBuildInputs = [ makeWrapper ];
  } ''
    mkdir -p $out/bin

    makeWrapper ${python.interpreter} $out/bin/coq-kernel \
      --add-flags "-m coq_jupyter" \
      --suffix PATH : ${coq}/bin
  '';

  definition = definitionWithPackages [];

  definitionWithPackages = packages: {
    displayName = "Coq " + coq.version;
    argv = [
      "${launcher}/bin/coq-kernel"
      "-f"
      "{connection_file}"
    ];
    language = "coq";
    logo32 = "${logos}/logo-32x32.png";
    logo64 = "${logos}/logo-64x64.png";
    env = {
      COQPATH = lib.concatStringsSep ":" (map (x: "${x}/lib/coq/${coq.coq-version}/user-contrib/") packages);
    };
  };
}
