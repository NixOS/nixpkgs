{
  lib,
  stdenv,
  fetchurl,
  lv2,
  meson,
  ninja,
  pkg-config,
  serd,
  sord,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sratom";
  version = "0.6.20";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://download.drobilla.net/sratom-${finalAttrs.version}.tar.xz";
    hash = "sha256-OCbpGGyrxDyl41n8w9gjgGAjL1+KIJC+XcmrOQ5bZHc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    lv2
    serd
    sord
  ];

  postPatch = ''
    patchShebangs --build scripts/dox_to_sphinx.py
  '';

  mesonFlags = [
    "-Ddocs=disabled"
  ];

  passthru = {
    updateScript = writeScript "update-sratom" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre2 common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of 'download.drobilla.net/sratom-0.30.16.tar.xz">'
      new_version="$(curl -s https://drobilla.net/category/sratom/ | pcre2grep -o1 'Sratom ([0-9]+\.[0-9]+\.[0-9]+)' | sort -V | tail -n1)"
      update-source-version sratom "$new_version"
    '';
  };

  meta = {
    homepage = "https://drobilla.net/software/sratom";
    description = "Library for serialising LV2 atoms to/from RDF";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
