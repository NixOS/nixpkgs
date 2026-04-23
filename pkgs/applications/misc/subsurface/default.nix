{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  writeShellScriptBin,
  cmake,
  wrapQtAppsHook,
  pkg-config,
  qmake,
  curl,
  grantlee,
  hidapi,
  libgit2,
  libssh2,
  libusb1,
  libxml2,
  libxslt,
  libzip,
  zlib,
  qtbase,
  qtconnectivity,
  qtlocation,
  qtsvg,
  qttools,
  qtpositioning,
  libxcomposite,
  bluez,
  writeScript,
}:

let
  version = "6.0.5504";

  subsurfaceSrc = (
    fetchFromGitHub {
      owner = "Subsurface";
      repo = "subsurface";
      rev = "28ad7132d2283a3fc06872de6526bc19c077d203";
      hash = "sha256-PQwBfm4oPGLU1HRFIcbgTYOYLeVhmEBgN5U8fnUMMlQ=";
      fetchSubmodules = true;
    }
  );

  libdc = stdenv.mkDerivation {
    pname = "libdivecomputer-ssrf";
    inherit version;

    src = subsurfaceSrc;

    sourceRoot = "${subsurfaceSrc.name}/libdivecomputer";

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ];

    buildInputs = [
      zlib
      libusb1
      bluez
      hidapi
    ];

    enableParallelBuilding = true;

    meta = {
      homepage = "https://www.libdivecomputer.org";
      description = "Cross-platform and open source library for communication with dive computers from various manufacturers";
      maintainers = with lib.maintainers; [ mguentner ];
      license = lib.licenses.lgpl21;
      platforms = lib.platforms.all;
    };
  };

  googlemaps = stdenv.mkDerivation rec {
    pname = "googlemaps";
    version = "0.0.0.2";

    src = fetchFromGitHub {
      owner = "vladest";
      repo = "googlemaps";
      rev = "v.${version}";
      hash = "sha256-PfSLFQeCeVNcCVDCZehxyNLQGT6gff5jNxMW8lAaP8c=";
    };

    nativeBuildInputs = [ qmake ];

    buildInputs = [
      qtbase
      qtlocation
      libxcomposite
    ];

    dontWrapQtApps = true;

    pluginsSubdir = "lib/qt-${qtbase.qtCompatVersion}/plugins";

    installPhase = ''
      mkdir -p $out $(dirname ${pluginsSubdir}/geoservices)
      mkdir -p ${pluginsSubdir}/geoservices
      mv *.so ${pluginsSubdir}/geoservices
      mv lib $out/
    '';

    meta = {
      inherit (src.meta) homepage;
      description = "QtLocation plugin for Google maps tile API";
      maintainers = [ ];
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  };

  get-version = writeShellScriptBin "get-version" ''
    echo -n ${version}
  '';

in
stdenv.mkDerivation {
  pname = "subsurface";
  inherit version;

  src = subsurfaceSrc;

  postPatch = ''
    install -m555 -t scripts ${lib.getExe get-version}
  '';

  buildInputs = [
    bluez
    curl
    googlemaps
    grantlee
    libdc
    libgit2
    libssh2
    libxml2
    libxslt
    libzip
    qtbase
    qtconnectivity
    qtsvg
    qttools
    qtpositioning
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    pkg-config
  ];

  cmakeFlags = [
    "-DLIBDC_FROM_PKGCONFIG=ON"
    "-DNO_PRINTING=OFF"
  ];

  passthru = {
    inherit version libdc googlemaps;
    updateScript = writeScript "update-subsurface" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p git common-updater-scripts

      set -eu -o pipefail
      tmpdir=$(mktemp -d)
      pushd $tmpdir
      git clone -b current https://github.com/subsurface/subsurface.git
      cd subsurface
      sed -i '1s/#!\/bin\/bash/#!\/usr\/bin\/env bash/' ./scripts/get-version.sh
      # this returns 6.0.????-local
      new_version=$(./scripts/get-version.sh | cut -d '-' -f 1)
      new_rev=$(git rev-list -1 HEAD)
      popd
      update-source-version subsurface "$new_version" --rev="$new_rev"
      rm -rf $tmpdir
    '';
  };

  meta = {
    description = "Divelog program";
    mainProgram = "subsurface";
    longDescription = ''
      Subsurface can track single- and multi-tank dives using air, Nitrox or TriMix.
      It allows tracking of dive locations including GPS coordinates (which can also
      conveniently be entered using a map interface), logging of equipment used and
      names of other divers, and lets users rate dives and provide additional notes.
    '';
    homepage = "https://subsurface-divelog.org";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ mguentner ];
    platforms = lib.platforms.all;
  };
}
