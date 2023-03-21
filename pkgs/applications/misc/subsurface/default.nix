{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, writeShellScriptBin
, cmake
, wrapQtAppsHook
, pkg-config
, qmake
, curl
, grantlee
, hidapi
, libgit2
, libssh2
, libusb1
, libxml2
, libxslt
, libzip
, zlib
, qtbase
, qtconnectivity
, qtlocation
, qtsvg
, qttools
, qtwebengine
, libXcomposite
, bluez
}:

let
  version = "5.0.10";

  subsurfaceSrc = (fetchFromGitHub {
    owner = "Subsurface";
    repo = "subsurface";
    rev = "v${version}";
    hash = "sha256-KzUBhFGvocaS1VrVT2stvKrj3uVxYka+dyYZUfkIoNs=";
    fetchSubmodules = true;
  });

  libdc = stdenv.mkDerivation {
    pname = "libdivecomputer-ssrf";
    inherit version;

    src = subsurfaceSrc;

    sourceRoot = "source/libdivecomputer";

    nativeBuildInputs = [ autoreconfHook pkg-config ];

    buildInputs = [ zlib libusb1 bluez hidapi ];

    enableParallelBuilding = true;

    meta = with lib; {
      homepage = "https://www.libdivecomputer.org";
      description = "A cross-platform and open source library for communication with dive computers from various manufacturers";
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

    buildInputs = [ qtbase qtlocation libXcomposite ];

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
      maintainers = with maintainers; [ orivej ];
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
    qtwebengine
  ];

  nativeBuildInputs = [ cmake wrapQtAppsHook pkg-config ];

  cmakeFlags = [
    "-DLIBDC_FROM_PKGCONFIG=ON"
    "-DNO_PRINTING=OFF"
  ];

  passthru = { inherit version libdc googlemaps; };

  meta = with lib; {
    description = "A divelog program";
    longDescription = ''
      Subsurface can track single- and multi-tank dives using air, Nitrox or TriMix.
      It allows tracking of dive locations including GPS coordinates (which can also
      conveniently be entered using a map interface), logging of equipment used and
      names of other divers, and lets users rate dives and provide additional notes.
    '';
    homepage = "https://subsurface-divelog.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mguentner adisbladis ];
    platforms = platforms.all;
  };
}
