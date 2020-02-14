{ stdenv, lib, fetchFromGitHub, fetchFromGitiles, pkgconfig, libssh2
, qtbase, qtdeclarative, qtgraphicaleffects, qtimageformats, qtquickcontrols
, qtsvg, qttools, qtquick1, qtcharts
, qmake
}:

let
  breakpad_lss = fetchFromGitiles {
    url = "https://chromium.googlesource.com/linux-syscall-support";
    rev = "08056836f2b4a5747daff75435d10d649bed22f6";
    sha256 = "1ryshs2nyxwa0kn3rlbnd5b3fhna9vqm560yviddcfgdm2jyg0hz";
  };

in

stdenv.mkDerivation rec {
  pname = "redis-desktop-manager";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "uglide";
    repo = "RedisDesktopManager";
    fetchSubmodules = true;
    rev = version;
    sha256 = "0yd4i944d4blw8jky0nxl7sfkkj975q4d328rdcbhizwvf6dx81f";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [
    libssh2 qtbase qtdeclarative qtgraphicaleffects qtimageformats
    qtquick1 qtquickcontrols qtsvg qttools qtcharts
  ];

  dontUseQmakeConfigure = true;

  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated" ];

  # Disable annoying update reminder
  postPatch = ''
    sed -i s/'^\s*initUpdater();'/'\/\/initUpdater():'/ src/app/app.cpp
  '';

  buildPhase = ''
    srcdir=$PWD

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
  '';

  meta = with lib; {
    description = "Cross-platform open source Redis DB management tool";
    homepage = https://redisdesktop.com/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
