{ stdenv, lib, fetchgit, pkgconfig , libssh2
, qtbase, qtdeclarative, qtgraphicaleffects, qtimageformats, qtquickcontrols
, qtsvg, qttools, qtquick1
, makeQtWrapper, qmakeHook
}:

let
  breakpad_lss = fetchgit {
    url = "https://chromium.googlesource.com/linux-syscall-support";
    rev = "08056836f2b4a5747daff75435d10d649bed22f6";
    sha256 = "1ryshs2nyxwa0kn3rlbnd5b3fhna9vqm560yviddcfgdm2jyg0hz";
  };

in

stdenv.mkDerivation rec {
  name = "redis-desktop-manager-${version}";
  version = "0.8.3";

  src = fetchgit {
    url = "https://github.com/uglide/RedisDesktopManager.git";
    fetchSubmodules = true;
    rev = "refs/tags/${version}";
    sha256 = "08969xwqpjgvfa195dxskpr54p4mnapgfykcffpqpczp990ak1l6";
  };

  nativeBuildInputs = [ makeQtWrapper qmakeHook ];

  buildInputs = [
    pkgconfig libssh2 qtbase qtdeclarative qtgraphicaleffects qtimageformats
    qtquick1 qtquickcontrols qtsvg qttools
  ];

  configurePhase = "true";

  buildPhase = ''
    srcdir=$PWD

    substituteInPlace src/resources/qml/ValueTabs.qml \
      --replace "import QtQuick.Controls 1.4" \
                "import QtQuick.Controls 1.2"

    cat <<EOF > src/version.h
#ifndef RDM_VERSION
    #define RDM_VERSION "${version}-120"
#endif // !RDM_VERSION
EOF

    cd $srcdir/3rdparty/gbreakpad
    cp -r ${breakpad_lss} src/third_party/lss
    chmod +w -R src/third_party/lss
    touch README

    cd $srcdir/3rdparty/crashreporter
    qmake CONFIG+=release DESTDIR="$srcdir/rdm/bin/linux/release" QMAKE_LFLAGS_RPATH=""
    make

    cd $srcdir/3rdparty/gbreakpad
    ./configure
    make

    cd $srcdir/src
    qmake
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    instdir="$srcdir/bin/linux/release"
    cp $instdir/rdm $out/bin
    wrapQtProgram $out/bin/rdm
  '';

  meta = with lib; {
    description = "Cross-platform open source Redis DB management tool";
    homepage = "http://redisdesktop.com/";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
