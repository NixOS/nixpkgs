{ stdenv, fetchFromGitHub
, perl, xulrunner, cmake, perlPackages, zip, unzip, pkgconfig
, libpulseaudio, glib, gtk, pixman, nspr, nss, libXScrnSaver
, scrnsaverproto
}:

stdenv.mkDerivation rec {
  name = "oneteam-unstable-2013-02-21";

  src = fetchFromGitHub {
    repo = "oneteam";
    owner = "processone";
    rev = "c51bc545c3a32db4ea8b96e43b84fcfc6b8d3d2a";
    sha256 = "19104fwdaf0nnsr5w755fg8wwww5sh96wmn939gxa5ah155nf2w3";
  };

  nativeBuildInputs = [ pkgconfig cmake zip unzip ];

  buildInputs =
    [ perl xulrunner libpulseaudio glib gtk pixman nspr
      nss libXScrnSaver scrnsaverproto
    ] ++ [ perlPackages.SubName gtk glib ];

  postPatch = ''
    sed -e '1i#include <netinet/in.h>' -i src/rtp/otRTPDecoder.cpp src/rtp/otRTPEncoder.cpp
  '';

  cmakeBuildDir = "cmake-build";
  cmakeFlags = ["-D XPCOM_GECKO_SDK=${xulrunner}/lib/xulrunner-devel-${xulrunner.version}"];

  buildPhase = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${nspr.dev}/include/nspr"
    cd src/components
    perl build.pl XULAPP 1
    cd ../../
  '';

  installPhase = ''
    TARGET_DIR="$out/share/oneteam/app"
    BUILD_DIR="$PWD"
    mkdir -p "$TARGET_DIR"
    cd "$TARGET_DIR"
    unzip "$BUILD_DIR/oneteam.xulapp"
    mkdir -p "$out/bin"
    echo "#! ${stdenv.shell}" > "$out/bin/oneteam"
    echo "\"${xulrunner}/bin/xulrunner\" \"$TARGET_DIR/application.ini\"" > "$out/bin/oneteam"
    chmod a+x "$out/bin/oneteam"
    mkdir -p "$out/share/doc"
    cp -r "$BUILD_DIR/docs" "$out/share/doc/oneteam"
  '';

  meta = {
    description = "An XMPP client";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    license = stdenv.lib.licenses.gpl2;
    homepage="http://oneteam.im";
  };

  passthru = {
    updateInfo = {
      downloadPage = "git://github.com/processone/oneteam";
    };
  };
}
