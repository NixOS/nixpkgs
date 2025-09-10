{
  lib,
  callPackage,
  runCommand,
  makeWrapper,
  coq,
  imagemagick,
  python312,
}:

# Jupyter console:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel coq-kernel.definition'

# Jupyter console with packages: (using Coq 8.20, before the Rocq transition at version 9.0)
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter-console.withSingleKernel ((coq-kernel.override { coq = coq_8_20; }).definitionWithPackages (with coqPackages_8_20; [bignums stdlib]))'

# Jupyter notebook:
# nix run --impure --expr 'with import <nixpkgs> {}; jupyter.override { definitions.coq = coq-kernel.definition; }'

let
  # Nixpkgs master is currently on python3 >= python313. This doesn't work with
  # this package, because it depends on the "future" package, which is no longer
  # compatible with Python 3.13.

  coq-jupyter = callPackage ./kernel.nix {
    inherit coq;
    python3 = python312;
  };

  python = python312.withPackages (ps: [
    ps.traitlets
    ps.jupyter-core
    ps.ipykernel
    coq-jupyter
  ]);

  # At version 9.0, Coq underwent a name change to Rocq.
  # A couple paths and environment variables need to change at this point.
  isRocq = lib.versionAtLeast coq.coq-version "9.0";

  logos =
    let
      dir = if isRocq then "rocqide" else "coqide";
    in
    runCommand "coq-logos" { buildInputs = [ imagemagick ]; } ''
      mkdir -p $out
      convert ${coq.src}/ide/${dir}/coq.png -resize 32x32 $out/logo-32x32.png
      convert ${coq.src}/ide/${dir}/coq.png -resize 64x64 $out/logo-64x64.png
    '';

  launcher =
    runCommand "coq-kernel-launcher"
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        mkdir -p $out/bin

        makeWrapper ${python.interpreter} $out/bin/coq-kernel \
          --add-flags "-m coq_jupyter" \
          --suffix PATH : ${coq}/bin
      '';

  definitionWithPackages = packages: {
    displayName = (if isRocq then "Rocq " else "Coq ") + coq.version;
    argv = [
      "${launcher}/bin/coq-kernel"
      "-f"
      "{connection_file}"
    ];
    language = "coq";
    logo32 = "${logos}/logo-32x32.png";
    logo64 = "${logos}/logo-64x64.png";
    env = lib.listToAttrs [
      {
        name = if isRocq then "ROCQPATH" else "COQPATH";
        value = lib.concatStringsSep ":" (
          map (x: "${x}/lib/coq/${coq.coq-version}/user-contrib/") packages
        );
      }
      {
        name = "OCAMLPATH";
        value = lib.concatStringsSep ":" (
          map (x: "${x}/lib/ocaml/${coq.ocaml.version}/site-lib/") ([ coq.ocamlPackages.findlib ] ++ packages)
        );
      }
    ];
  };

in

launcher.overrideAttrs (_oldAttrs: {
  passthru = {
    inherit coq-jupyter definitionWithPackages logos;
    definition = definitionWithPackages [ ];
  };
})
