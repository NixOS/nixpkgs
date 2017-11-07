{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, cmake, makeWrapper, pkgconfig, qmake
, curl, grantlee, libgit2, libusb, libssh2, libxml2, libxslt, libzip, zlib
, qtbase, qtconnectivity, qtlocation, qtsvg, qttools, qtwebkit
}:

let
  version = "4.7.2";

  libdc = stdenv.mkDerivation rec {
    name = "libdivecomputer-ssrf-${version}";

    src = fetchurl {
      url = "https://subsurface-divelog.org/downloads/libdivecomputer-subsurface-branch-${version}.tgz";
      sha256 = "04wadhhva1bfnwk0kl359kcv0f83mgym2fzs441spw5llcl7k52r";
    };

    nativeBuildInputs = [ autoreconfHook ];

    buildInputs = [ zlib ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      homepage = http://www.libdivecomputer.org;
      description = "A cross-platform and open source library for communication with dive computers from various manufacturers";
      maintainers = with maintainers; [ mguentner ];
      license = licenses.lgpl21;
      platforms = platforms.all;
    };
  };

  googlemaps = stdenv.mkDerivation rec {
    name = "googlemaps-${version}";

    version = "2017-09-17";

    src = fetchFromGitHub {
      owner = "vladest";
      repo = "googlemaps";
      rev = "1b857c02504dd52b1aa442418b8dcea78ced3f35";
      sha256 = "14icmc925g4abwwdrldjc387aiyvcp3ia5z7mfh9qa09bv829a84";
    };

    nativeBuildInputs = [ qmake ];

    buildInputs = [ qtbase qtlocation ];

    pluginsSubdir = "lib/qt-${qtbase.qtCompatVersion}/plugins";

    installPhase = ''
      mkdir $out $(dirname ${pluginsSubdir})
      mv plugins ${pluginsSubdir}
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

in stdenv.mkDerivation rec {
  name = "subsurface-${version}";

  src = fetchurl {
    url = "https://subsurface-divelog.org/downloads/Subsurface-${version}.tgz";
    sha256 = "06f215xx1nc2q2qff2ihcl86fkrlnkvacl1swi3fw9iik6nq3bjp";
  };

  buildInputs = [
    libdc googlemaps
    curl grantlee libgit2 libssh2 libusb libxml2 libxslt libzip
    qtbase qtconnectivity qtsvg qttools qtwebkit
  ];

  nativeBuildInputs = [ cmake makeWrapper pkgconfig ];

  cmakeFlags = [
    "-DLIBDC_FROM_PKGCONFIG=ON"
    "-DNO_PRINTING=OFF"
  ];

  postInstall = ''
    wrapProgram $out/bin/subsurface \
      --prefix QT_PLUGIN_PATH : "${googlemaps}/${googlemaps.pluginsSubdir}"
  '';

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
    homepage = https://subsurface-divelog.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ mguentner ];
    platforms = platforms.all;
  };
}
