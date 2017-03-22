{ stdenv, fetchFromGitHub
, perl, firefox, perlPackages, zip, unzip, pkgconfig
, libpulseaudio, glib, gtk2, pixman, nspr, nss, libXScrnSaver
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

  nativeBuildInputs = [ pkgconfig zip unzip ];

  buildInputs =
    [ perl firefox libpulseaudio glib gtk2 pixman nspr
      nss libXScrnSaver scrnsaverproto
    ] ++ [ perlPackages.SubName gtk2 glib ];

  postPatch = ''
    sed -e '1i#include <netinet/in.h>' -i src/components/src/rtp/otRTPDecoder.cpp src/components/src/rtp/otRTPEncoder.cpp
  '';

  buildPhase = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${nspr.dev}/include/nspr"
    perl build.pl XULAPP 1
  '';

  installPhase = ''
    TARGET_DIR="$out/share/oneteam/app"
    BUILD_DIR="$PWD"
    mkdir -p "$TARGET_DIR"
    cd "$TARGET_DIR"
    unzip "$BUILD_DIR/oneteam.xulapp"
    mkdir -p "$out/bin"
    echo "#! ${stdenv.shell}" > "$out/bin/oneteam"
    sed -re 's@MaxVersion=[0-9.]+@MaxVersion=999.0@' -i "$TARGET_DIR/application.ini"
    echo "\"${firefox}/bin/firefox\" -app \"$TARGET_DIR/application.ini\"" > "$out/bin/oneteam"
    chmod a+x "$out/bin/oneteam"
    mkdir -p "$out/share/doc"
    cp -r "$BUILD_DIR/docs" "$out/share/doc/oneteam"
  '';

  meta = {
    description = "An XMPP client";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    license = stdenv.lib.licenses.gpl2;
    homepage="http://oneteam.im";
    # Fell behind the Firefox development
    broken = true;
  };

  passthru = {
    updateInfo = {
      downloadPage = "git://github.com/processone/oneteam";
    };
  };
}
