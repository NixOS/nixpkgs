{ stdenvNoCC, lib, bower2nix, cacert }:
let
  bowerVersion = version:
    let
      components = lib.splitString "#" version;
      hash = lib.last components;
      ver = if builtins.length components == 1 then (cleanName version) else hash;
    in ver;

  cleanName = name: lib.replaceStrings ["/" ":"] ["-" "-"] name;

  fetchbower = name: version: target: outputHash: stdenvNoCC.mkDerivation {
    name = "${cleanName name}-${bowerVersion version}";
    buildCommand = ''
      fetch-bower --quiet --out=$PWD/out "${name}" "${target}" "${version}"
      # In some cases, the result of fetchBower is different depending
      # on the output directory (e.g. if the bower package contains
      # symlinks). So use a local output directory before copying to
      # $out.
      cp -R out $out
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    inherit outputHash;
    nativeBuildInputs = [ bower2nix cacert ];
  };

in fetchbower
