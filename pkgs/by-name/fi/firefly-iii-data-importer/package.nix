{ stdenv, unzip }:
let
  version = "1.5.2";
in
stdenv.mkDerivation rec {
  pname = "firefly-iii-data-importer";
  inherit version;

  src = builtins.fetchurl {
    url = "https://github.com/firefly-iii/data-importer/releases/download/v${version}/DataImporter-v${version}.zip";
    sha256 = "sha256:1ssxhgd6x4lp8ak5zkgj02hvpvdsgxafli9syb9lwrkkr9z8lyyg";
  };

  buildInputs = [ unzip ];

  phases = [
    "unpackPhase"
    "patchPhase"
    "installPhase"
  ];

  unpackPhase = ''
    unzip $src
  '';

  postPatch = ''
    # Get the storage directory from the env variable instead of in the nix store
    sed -i "s/app()->storagePath/env('FF3_DATA_IMPORTER_STORAGE') . '\/' . \$path; #/g" \
      vendor/laravel/framework/src/Illuminate/Foundation/helpers.php
  '';

  installPhase = ''
    cp -r . $out
  '';
}
