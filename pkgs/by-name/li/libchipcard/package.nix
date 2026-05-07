{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gwenhywfar,
  pcsclite,
  zlib,
  writeScript,
}:

stdenv.mkDerivation rec {
  pname = "libchipcard";
  version = "5.1.6";
  releaseId = "382";

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/${releaseId}/libchipcard-${version}.tar.gz";
    hash = "sha256-bAf1J0F/dWIHT5kBLaTRHrTbr9M/SeZrRCzNbjuM/SA=";
  };

  passthru = {
    updateScript = writeScript "update-libchipcard" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnugrep gnused coreutils common-updater-scripts

      set -eu -o pipefail

      url="https://www.aquamaniac.de/rdm/projects/libchipcard/files"

      # Extract all download paths for the tar.gz archives
      downloads=$(curl -s "$url" | grep -Po 'attachments/download/\d+/libchipcard-\d+\.\d+\.\d+\.tar\.gz')

      # Use version sort (-V) to find the highest version number
      latest_version=$(echo "$downloads" | grep -Po '\d+\.\d+\.\d+' | sort -V | tail -n 1)

      # Grab the exact download path for that specific highest version
      latest_download=$(echo "$downloads" | grep "libchipcard-$latest_version\.tar\.gz" | head -n 1)
      latest_release_id=$(echo "$latest_download" | cut -d'/' -f3)

      # Update the releaseId statically inside this nix file
      sed -i "s/releaseId = \"[0-9]\+\";/releaseId = \"$latest_release_id\";/" pkgs/by-name/li/libchipcard/package.nix

      # Update the version and hash using the standard Nixpkgs tool
      update-source-version libchipcard "$latest_version"
    '';
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gwenhywfar
    pcsclite
    zlib
  ];

  makeFlags = [ "crypttokenplugindir=$(out)/lib/gwenhywfar/plugins/ct" ];

  meta = {
    description = "Library for access to chipcards";
    homepage = "https://www.aquamaniac.de/rdm/projects/libchipcard";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ aszlig ];
    platforms = lib.platforms.linux;
  };
}
