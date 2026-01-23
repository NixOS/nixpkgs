{
  autoconf,
  automake,
  autoPatchelfHook,
  cups,
  fetchpatch2,
  fetchzip,
  glib,
  lib,
  libtool,
  libusb1,
  libxml2,
  stdenv,
}:
let
  blobDir = "com/libs_bin_${stdenv.hostPlatform.uname.processor}";
in
stdenv.mkDerivation {
  pname = "cnijfilter2";
  version = "6.90-1";

  src = fetchzip {
    url = "https://gdlp01.c-wss.com/gds/9/0100012819/01/cnijfilter2-source-6.90-1.tar.gz";
    hash = "sha256-kvMEC2IR448JAM8unoLzF01GDlWhTSk/gi6giHI0u0E=";
  };

  patches = [
    ./stdlib.patch
    ./bool.patch

    # See:
    # - https://github.com/NixOS/nixpkgs/pull/180681#issuecomment-1192304711
    # - https://bugs.gentoo.org/723186
    (fetchpatch2 {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/net-print/cnijfilter2/files/cnijfilter2-5.80-fno-common.patch?id=24688d64544b43f2c14be54531ad8764419dde09";
      hash = "sha256-ygAfS68100ducWsxeA2Q2eoE8cBFMVO7KiXn/RGIHFw=";
    })
  ];

  nativeBuildInputs = [
    automake
    autoconf
    autoPatchelfHook
    glib
    libtool
  ];

  buildInputs = [
    cups
    libusb1
    libxml2
  ];

  postPatch = ''
    substituteInPlace lgmon3/src/Makefile.am \
      --replace-fail /usr/include/libusb-1.0 ${lib.getDev libusb1}/include/libusb-1.0
  '';

  preConfigure = ''
    for i in cmdtocanonij2 cmdtocanonij3 cnijbe2 lgmon3 rastertocanonij tocanonij tocnpwg; do
      cd $i
      env NOCONFIGURE=1 ./autogen.sh
      cd ..
    done
  '';

  configurePhase = ''
    runHook preConfigure
    for i in cmdtocanonij2 cmdtocanonij3 cnijbe2 lgmon3 rastertocanonij tocanonij tocnpwg; do
      cd $i
      configureFlags="--build=${stdenv.buildPlatform.config}"
      configureFlags="$configureFlags --host=${stdenv.hostPlatform.config}"
      configureFlags="$configureFlags --target=${stdenv.targetPlatform.config}"
      configureFlags="$configureFlags --prefix=$out --disable-dependency-tracking --disable-static"
      if [ $i = cnijbe2 -o $i = lgmon3 -o $i = rastertocanonij ]; then
        configureFlags="$configureFlags --enable-progpath=$out/bin"
      fi
      if [ $i = lgmon3 ]; then
        # lgmon3's --enable-libdir flag is used solely for specifying in which
        # directory the cnnnet.ini cache file should reside.
        # NixOS uses /var/cache/cups, and given the name, it seems like a reasonable
        # place to put the cnnet.ini file, and thus we do so.
        configureFlags="$configureFlags --enable-libpath=/var/cache/cups"
      fi
      ./configure $configureFlags
      cd ..
    done
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    for i in cmdtocanonij2 cmdtocanonij3 cnijbe2 lgmon3 rastertocanonij tocanonij tocnpwg; do
      cd $i
      make
      cd ..
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    for i in cmdtocanonij2 cmdtocanonij3 cnijbe2 lgmon3 rastertocanonij tocanonij tocnpwg; do
      cd $i
      make install
      cd ..
    done
    runHook postInstall
  '';

  postInstall = ''
    install -Dm755 -t $out/lib ${blobDir}/*
    install -Dm644 -t $out/share/cups/model ppd/*.ppd
  '';

  runtimeDependencies = [ (placeholder "out") ];

  env = {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev libxml2}/include/libxml2";
    NIX_LDFLAGS = "-L../../${blobDir}";
  };

  meta = {
    description = "Canon InkJet printer drivers for many Pixma series printers";
    longDescription = ''
      Canon InkJet printer drivers for series BX110, E200, E300, E460, E470,
      E480, E3100, E3300, E3400, E3600, E4200, E4500, G500, G600, G1020, G1030,
      G2020, G2030, G2060, G2070, G3000, G3010, G3020, G3030, G3060, G3070,
      G3080, G3090, G4000, G4010, G4070, G4080, G4090, G5000, G5080, G6000,
      G6080, G7000, G7080, GM2000, GM2080, GM4000, GM4080, GX1000, GX2000,
      GX3000, GX4000, GX4000i, GX5000, GX5100, GX5500, GX6000, GX6100, GX6500,
      GX7000, GX7100, GX7100i, iB4000, iB4100, iP110, MB2000, MB2100, MB2300,
      MB2700, MB5000, MB5100, MB5300, MB5400, MG2900, MG3000, MG3600, MG5600,
      MG5700, MG6600, MG6800, MG6900, MG7500, MG7700, MX490, TR150, TR160,
      TR703, TR4500, TR4600, TR4700, TR7000, TR7100, TR7500, TR7530, TR7600,
      TR7800, TR8500, TR8530, TR8580, TR8600, TR8630, TR9530, TS200, TS300,
      TS700, TS708, TS2400, TS2600, TS3100, TS3300, TS3400, TS3500, TS3600,
      TS3700, TS4000, TS4100i, TS4300, TS5000, TS5100, TS5300, TS5350i, TS5380,
      TS5400, TS5500, TS5630, TS6000, TS6100, TS6130, TS6180, TS6200, TS6230,
      TS6280, TS6300, TS6330, TS6380, TS6400, TS6500, TS6500i, TS6630, TS6730,
      TS7330, TS7400, TS7430, TS7450i, TS7500i, TS7530, TS7600i, TS7630, TS7700,
      TS7700A, TS7700i, TS8000, TS8100, TS8130, TS8180, TS8200, TS8230, TS8280,
      TS8300, TS8330, TS8380, TS8430, TS8530, TS8630, TS8700, TS8800, TS8930,
      TS9000, TS9100, TS9180, TS9500, TS9580, XK50, XK60, XK70, XK80, XK90,
      XK100, XK110, XK120, XK130, XK140, XK500, XK510.
    '';
    downloadPage = "https://hk.canon/en/support/0101281901";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ prince213 ];
    platforms = [
      "aarch64-linux"
      "i686-linux"
      "mips64el-linux"
      "x86_64-linux"
    ];
  };
}
