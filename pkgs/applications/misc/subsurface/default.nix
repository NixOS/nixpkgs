{ lib, stdenv, fetchurl, fetchFromGitHub, autoreconfHook, cmake, wrapQtAppsHook, pkg-config, qmake
, curl, grantlee, libgit2, libusb-compat-0_1, libssh2, libxml2, libxslt, libzip, zlib
, qtbase, qtconnectivity, qtlocation, qtsvg, qttools, qtwebkit, libXcomposite
, bluez
}:

let
  version = "5.0.2";

  subsurfaceSrc = (fetchFromGitHub {
    owner = "Subsurface";
    repo = "subsurface";
    rev = "v${version}";
    sha256 = "1yay06m8p9qp2ghrg8dxavdq55y09apcgdnb7rihgs3hq86k539n";
    fetchSubmodules = true;
  });

  libdc = stdenv.mkDerivation {
    pname = "libdivecomputer-ssrf";
    inherit version;

    src = subsurfaceSrc;

    prePatch = "cd libdivecomputer";

    nativeBuildInputs = [ autoreconfHook ];

    buildInputs = [ zlib ];

    enableParallelBuilding = true;

    meta = with lib; {
      homepage = "http://www.libdivecomputer.org";
      description = "A cross-platform and open source library for communication with dive computers from various manufacturers";
      maintainers = with maintainers; [ mguentner ];
      license = licenses.lgpl21;
      platforms = platforms.all;
    };
  };

  googlemaps = stdenv.mkDerivation rec {
    pname = "googlemaps";

    version = "2021-03-19";

    src = fetchFromGitHub {
      owner = "vladest";
      repo = "googlemaps";
      rev = "8f7def10c203fd3faa5ef96c5010a7294dca0759";
      sha256 = "1irz398g45hk6xizwzd07qcx1ln8f7l6bhjh15f56yc20waqpx1x";
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

in stdenv.mkDerivation {
  pname = "subsurface";
  inherit version;

  src = subsurfaceSrc;

  buildInputs = [
    libdc googlemaps
    curl grantlee libgit2 libssh2 libusb-compat-0_1 libxml2 libxslt libzip
    qtbase qtconnectivity qtsvg qttools qtwebkit
    bluez
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
