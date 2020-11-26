{ pkgs ? (import ./.. { })
}:

with pkgs;

let
  toc = import ./toc.nix;

  # Some files get included in the build directory, but are
  # only needed when doing the old docbook build.
  unusedFiles = [
    "doc-support/parameters.xml"
    "manual.xml"
    "release-notes.xml" # Not used at all, should be removed
  ];

  # Take the source tree from the old docs, convert everything to .md
  # Temporary solution.
  mdInput = stdenv.mkDerivation {
    name = "nixpkgs-manual-md-input";
    src = ../doc;
    nativeBuildInputs = [
      pandoc
    ];

    buildPhase = ''
      for file in "${lib.concatStringsSep " " unusedFiles}"; do
        echo "Removing $file"
        rm $file
      done
    '';

    installPhase = ''
      mkdir -p $out
      # Convert Docbook to CommonMark
      for file in `find . -name "*.xml"`; do
        newfile="$out/''${file%.*}.md"
        echo "Converting $file to $newfile"
        mkdir -p "$out/$(dirname $file)"
        pandoc --from docbook --to commonmark "$file" -o "$newfile"
      done
      # Copy existing CommonMark files
      for file in `find . -name "*.md"`; do
        bname="$(basename $file)"
        # Remove section/chapter parts
        newfile="$out/$(dirname $file)/''${bname%%.*}.md"
        echo "Moving $file to $newfile"
        mkdir -p "$out/$(dirname $file)"
        cp "$file" "$newfile"
      done
    '';
  };

  logo = fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-homepage/053ef7b456d1333197b08bcb36700249d3291e55/logo/nixos-hex.svg";
    sha256 = "RIsQdOGgtgX3EngW4g6r/yEcYaNd9j9PFYJNxK3B1R8=";
  };

  # Build the manual
  manual = let
    tocForManual = builtins.toFile "toc.json" (builtins.toJSON toc);
  in callPackage (
    { stdenv
    , python3
    }:

    stdenv.mkDerivation {
      name = "nixpkgs-manual";

      src = ./.;

      nativeBuildInputs = [
        python3.pkgs.jupyter-book
      ];

      buildPhase = ''
        ln -s ${mdInput} doc
        cp ${tocForManual} _toc.yml
        cp ${logo} logo.svg
        jupyter-book build -n --keep-going .
      '';

      installPhase = ''
        mkdir -p $out/share/doc/nixpkgs-manual
        mv -T _build/html $out/share/doc/nixpkgs-manual
      '';

      passthru = {
        inherit logo mdInput toc;
      };
    }
  ) { };

in manual
