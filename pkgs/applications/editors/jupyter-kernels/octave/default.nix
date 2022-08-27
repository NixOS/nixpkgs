{ lib
, stdenv
, callPackage
, runCommand
, makeWrapper
, octave
, imagemagick
, python3
}:

# To test:
# $(nix-build -E 'with import <nixpkgs> {}; jupyter.override { definitions = { octave = octave-kernel.definition; }; }')/bin/jupyter-notebook

let
  kernel = callPackage ./kernel.nix {
    python3Packages = python3.pkgs;
  };

in

rec {
  launcher = runCommand "octave-kernel-launcher" {
    inherit octave;
    python = python3.withPackages (ps: [ ps.traitlets ps.jupyter_core ps.ipykernel ps.metakernel kernel ]);
    nativeBuildInputs = [ makeWrapper ];
  } ''
    mkdir -p $out/bin

    makeWrapper $python/bin/python $out/bin/octave-kernel \
      --add-flags "-m octave_kernel" \
      --suffix PATH : $octave/bin
  '';

  sizedLogo = size: stdenv.mkDerivation {
    pname = "octave-logo-${size}x${size}.png";
    inherit (octave) version;

    src = octave.src;

    buildInputs = [ imagemagick ];

    dontConfigure = true;
    dontInstall = true;

    buildPhase = ''
      convert ./libgui/src/icons/logo.png -resize ${size}x${size} $out
    '';
  };

  definition = {
    displayName = "Octave";
    argv = [
      "${launcher}/bin/octave-kernel"
      "-f"
      "{connection_file}"
    ];
    language = "octave";
    logo32 = sizedLogo "32";
    logo64 = sizedLogo "64";
  };
}
