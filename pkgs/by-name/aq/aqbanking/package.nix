{
  lib,
  stdenv,
  fetchurl,
  gmp,
  gwenhywfar,
  libtool,
  libxml2,
  libxslt,
  pkg-config,
  gettext,
  xmlsec,
  zlib,
  writeScript,
}:

stdenv.mkDerivation rec {
  pname = "aqbanking";
  version = "6.9.1";
  releaseId = "652";

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/${releaseId}/aqbanking-${version}.tar.gz";
    hash = "sha256-/JSivr+7T8JrmNyTyPo2qAJimM15lfeYIcSA2zVYf2s=";
  };

  passthru = {
    updateScript = writeScript "update-aqbanking" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnugrep gnused coreutils common-updater-scripts

      set -eu -o pipefail

      url="https://www.aquamaniac.de/rdm/projects/aqbanking/files"

      # Extract all download paths for the tar.gz archives
      downloads=$(curl -s "$url" | grep -Po 'attachments/download/\d+/aqbanking-\d+\.\d+\.\d+\.tar\.gz')

      # Use version sort (-V) to find the highest version number
      latest_version=$(echo "$downloads" | grep -Po '\d+\.\d+\.\d+' | sort -V | tail -n 1)

      # Grab the exact download path for that specific highest version
      latest_download=$(echo "$downloads" | grep -F "aqbanking-$latest_version.tar.gz" | head -n 1)
      latest_release_id=$(echo "$latest_download" | cut -d/ -f3)

      # Update the releaseId statically inside this nix file
      sed -i "s/releaseId = \"[0-9]\+\";/releaseId = \"$latest_release_id\";/" pkgs/by-name/aq/aqbanking/package.nix

      # Update the version and hash using the standard Nixpkgs tool
      update-source-version aqbanking "$latest_version"
    '';
  };

  # Set the include dir explicitly, this fixes a build error when building
  # kmymoney because otherwise the includedir is overwritten by gwenhywfar's
  # cmake file
  postPatch = ''
    sed -i '/^set_and_check(AQBANKING_INCLUDE_DIRS "@aqbanking_headerdir@")/i set_and_check(includedir "@includedir@")' aqbanking-config.cmake.in
    sed -i -e '/^aqbanking_plugindir=/ {
      c aqbanking_plugindir="\''${libdir}/gwenhywfar/plugins"
    }' configure
  '';

  buildInputs = [
    gmp
    gwenhywfar
    libtool
    libxml2
    libxslt
    xmlsec
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  meta = {
    description = "Interface to banking tasks, file formats and country information";
    homepage = "https://www.aquamaniac.de/rdm/";
    hydraPlatforms = [ ];
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
