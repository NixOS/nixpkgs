{
  stdenv,
  cmake, doxygen, pkgconfig, autoreconfHook,
  curl,
  fetchgit,
  grantlee,
  libgit2,
  libusb,
  libssh2,
  libxml2,
  libxslt,
  libzip,
  qtbase, qtconnectivity, qtquickcontrols, qtscript, qtsvg, qttools, qtwebkit,
  sqlite
}:

let
  version = "4.6.0";

  libmarble = stdenv.mkDerivation rec {
    name = "libmarble-ssrf-${version}";

    src = fetchgit {
      url    = "git://git.subsurface-divelog.org/marble";
      rev    = "refs/tags/v${version}";
      sha256 = "1dm2hdk6y36ls7pxbzkqmyc46hdy2cd5f6pkxa6nfrbhvk5f31zd";
    };

    buildInputs = [ qtbase qtquickcontrols qtscript qtwebkit ];
    nativeBuildInputs = [ doxygen pkgconfig cmake ];

    enableParallelBuilding = true;

    cmakeFlags = [
      "-DQTONLY=TRUE"
      "-DQT5BUILD=ON"
      "-DBUILD_MARBLE_TESTS=NO"
      "-DWITH_DESIGNER_PLUGIN=NO"
      "-DBUILD_MARBLE_APPS=NO"
    ];

    meta = with stdenv.lib; {
      description = "Qt library for a slippy map with patches from the Subsurface project";
      homepage = http://subsurface-divelog.org;
      license = licenses.lgpl21;
      maintainers = with maintainers; [ mguentner ];
      platforms = platforms.all;
    };
  };

  libdc = stdenv.mkDerivation rec {
    name = "libdivecomputer-ssrf-${version}";

    src = fetchgit {
      url    = "git://subsurface-divelog.org/libdc";
      rev    = "refs/tags/v${version}";
      sha256 = "0s82c8bvqph9c9chwzd76iwrw968w7lgjm3pj4hmad1jim67bs6n";
    };

    nativeBuildInputs = [ autoreconfHook ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      homepage = http://www.libdivecomputer.org;
      description = "A cross-platform and open source library for communication with dive computers from various manufacturers";
      maintainers = with maintainers; [ mguentner ];
      license = licenses.lgpl21;
      platforms = platforms.all;
    };
  };

in stdenv.mkDerivation rec {
  name = "subsurface-${version}";

  src = fetchgit {
    url    = "git://git.subsurface-divelog.org/subsurface";
    rev    = "refs/tags/v${version}";
    sha256 = "1rk5n52p6cnyjrgi7ybhmvh7y31zxrjny0mqpnc1wql69f90h94c";
  };

  buildInputs = [
    libdc libmarble
    curl grantlee libgit2 libssh2 libusb libxml2 libxslt libzip
    qtbase qtconnectivity qtsvg qttools qtwebkit
  ];
  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = false; # subsurfacewebservices.h dependency on ui_webservices.h

  cmakeFlags = [
    "-DMARBLE_LIBRARIES=${libmarble}/lib/libssrfmarblewidget.so"
    "-DNO_PRINTING=OFF"
  ];

  meta = with stdenv.lib; {
    description = "Subsurface is an open source divelog program that runs on Windows, Mac and Linux";
    longDescription = ''
      Subsurface can track single- and multi-tank dives using air, Nitrox or TriMix.
      It allows tracking of dive locations including GPS coordinates (which can also
      conveniently be entered using a map interface), logging of equipment used and
      names of other divers, and lets users rate dives and provide additional notes.
    '';
    homepage = https://subsurface-divelog.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ mguentner ];
    platforms = platforms.all;
  };
}
