{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, cmake, wrapQtAppsHook, pkgconfig, qmake
, curl, grantlee, libgit2, libusb, libssh2, libxml2, libxslt, libzip, zlib
, qtbase, qtconnectivity, qtlocation, qtsvg, qttools, qtwebkit, libXcomposite
}:

let
  version = "4.9.3";

  subsurfaceSrc = (fetchFromGitHub {
    owner = "Subsurface-divelog";
    repo = "subsurface";
    rev = "v${version}";
    sha256 = "1i07f7appifx9j205x5a7ng01wsipxr6n9a3692pm60jli2nsir5";
    fetchSubmodules = true;
  });

  libdc = stdenv.mkDerivation {
    pname = "libdivecomputer-ssrf";
    inherit version;

    src = subsurfaceSrc;
    sourceRoot = "source/libdivecomputer";

    nativeBuildInputs = [ autoreconfHook ];

    buildInputs = [ zlib ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      homepage = "http://www.libdivecomputer.org";
      description = "A cross-platform and open source library for communication with dive computers from various manufacturers";
      maintainers = with maintainers; [ mguentner ];
      license = licenses.lgpl21;
      platforms = platforms.all;
    };
  };

  googlemaps = stdenv.mkDerivation rec {
    pname = "googlemaps";

    version = "2017-12-18";

    src = fetchFromGitHub {
      owner = "vladest";
      repo = "googlemaps";
      rev = "79f3511d60dc9640de02a5f24656094c8982b26d";
      sha256 = "11334w0bnfb97sv23vvj2b5hcwvr0171hxldn91jms9y12l5j15d";
    };

    nativeBuildInputs = [ qmake ];

    buildInputs = [ qtbase qtlocation libXcomposite ];

    pluginsSubdir = "lib/qt-${qtbase.qtCompatVersion}/plugins";

    installPhase = ''
      mkdir -p $out $(dirname ${pluginsSubdir}/geoservices)
      mkdir -p ${pluginsSubdir}/geoservices
      mv *.so ${pluginsSubdir}/geoservices
      mv lib $out/
    '';

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
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

  # remove with the 4.10 release
  patches = [ ./0001-core-fix-libgit-ifdef-to-handle-libgit2-v1.0-and-onw.patch ];

  buildInputs = [
    libdc googlemaps
    curl grantlee libgit2 libssh2 libusb libxml2 libxslt libzip
    qtbase qtconnectivity qtsvg qttools qtwebkit
  ];

  nativeBuildInputs = [ cmake wrapQtAppsHook pkgconfig ];

  cmakeFlags = [
    "-DLIBDC_FROM_PKGCONFIG=ON"
    "-DNO_PRINTING=OFF"
  ];

  enableParallelBuilding = true;

  passthru = { inherit version libdc googlemaps; };

  meta = with stdenv.lib; {
    description = "A divelog program";
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
