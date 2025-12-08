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
  libXcomposite,
  bluez,
  writeScript,
}:

let
  version = "6.0.5436";

  subsurfaceSrc = (
    fetchFromGitHub {
      owner = "Subsurface";
      repo = "subsurface";
      rev = "2d3f73c2e1dd5d1f42419708866e40d973989d24";
      hash = "sha256-dB7KKXbQOmyzlzAKDlFTGJDa/XIKQeKsiCt+dPeP9EU=";
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

    meta = with lib; {
      homepage = "https://www.libdivecomputer.org";
      description = "Cross-platform and open source library for communication with dive computers from various manufacturers";
      maintainers = with maintainers; [ mguentner ];
      license = licenses.lgpl21;
      platforms = platforms.all;
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
      libXcomposite
    ];

    dontWrapQtApps = true;

    pluginsSubdir = "lib/qt-${qtbase.qtCompatVersion}/plugins";

    installPhase = ''
      mkdir -p $out $(dirname ${pluginsSubdir}/geoservices)
      mkdir -p ${pluginsSubdir}/geoservices
      mv *.so ${pluginsSubdir}/geoservices
      mv lib $out/
    '';

    meta = with lib; {
      inherit (src.meta) homepage;
      description = "QtLocation plugin for Google maps tile API";
      maintainers = [ ];
      license = licenses.mit;
      platforms = platforms.all;
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

  meta = with lib; {
    description = "Divelog program";
    mainProgram = "subsurface";
    longDescription = ''
      Subsurface can track single- and multi-tank dives using air, Nitrox or TriMix.
      It allows tracking of dive locations including GPS coordinates (which can also
      conveniently be entered using a map interface), logging of equipment used and
      names of other divers, and lets users rate dives and provide additional notes.
    '';
    homepage = "https://subsurface-divelog.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mguentner ];
    platforms = platforms.all;
  };
}
