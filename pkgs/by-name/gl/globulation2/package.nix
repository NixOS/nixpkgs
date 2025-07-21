{
  lib,
  stdenv,
  fetchurl,
  libGLU,
  libGL,
  SDL,
  scons,
  SDL_ttf,
  SDL_image,
  zlib,
  SDL_net,
  speex,
  libvorbis,
  libogg,
  boost,
  fribidi,
  bsdiff,
  fetchpatch,
}:
let
  version = "0.9.4";
  patchlevel = "4";
  tutorial4patch = fetchurl {
    url = "http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=34;filename=tutorial-part4.map.bspatch;att=1;bug=595448";
    name = "globulation2-tutorial4-map-patch-debian.bspatch";
    sha256 = "d3511ac0f822d512c42abd34b3122f2990862d3d0af6ce464ff372f5bd7f35e9";
  };
in
stdenv.mkDerivation rec {
  name = "glob2-${version}.${patchlevel}";

  src = fetchurl {
    url = "mirror://savannah/glob2/${version}/${name}.tar.gz";
    sha256 = "1f0l2cqp2g3llhr9jl6jj15k0wb5q8n29vqj99xy4p5hqs78jk8g";
  };

  patches = [
    ./header-order.patch
    ./public-buildproject.patch
    (fetchpatch {
      url = "https://bitbucket.org/giszmo/glob2/commits/c9dc715624318e4fea4abb24e04f0ebdd9cd8d2a/raw";
      sha256 = "0017xg5agj3dy0hx71ijdcrxb72bjqv7x6aq7c9zxzyyw0mkxj0k";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/glob2/0.9.4.4-6/debian/patches/10_pthread_underlinkage.patch";
      sha256 = "sha256-L9POADlkgQbUQEUmx4s3dxXG9tS0w2IefpRGuQNRMI0=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/glob2/0.9.4.4-6/debian/patches/link-boost-system.patch";
      sha256 = "sha256-ne6F2ZowB+TUmg3ePuUoPNxXI0ZJC6HEol3oQQHJTy4=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/glob2/0.9.4.4-6/debian/patches/scons.patch";
      sha256 = "sha256-Gah7SoVcd/Aljs0Nqo3YF0lZImUWtrGM4HbbQ4yrhHU=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/glob2/0.9.4.4-6/debian/patches/boost-1.69.patch";
      sha256 = "sha256-D7agFR4uyIHxQz690Q8EHPF+rTEoiGUpgkm7r5cL5SI=";
    })
  ];

  postPatch = ''
    cp campaigns/tutorial-part4.map{,.orig}
    bspatch  campaigns/tutorial-part4.map{.orig,} ${tutorial4patch}
    sed -i -e "s@env = Environment()@env = Environment( ENV = os.environ )@" SConstruct
  '';

  # fix sdl-config for cross
  # TODO: remaining *-config, and make it work for !(build.canExecute host)
  preBuild = ''
    substituteInPlace SConstruct \
      --replace-fail sdl-config "${lib.getExe' (lib.getDev SDL) "sdl-config"}"
  '';

  nativeBuildInputs = [
    scons
    bsdiff # bspatch
  ];
  buildInputs = [
    libGLU
    libGL
    SDL
    SDL_ttf
    SDL_image
    zlib
    SDL_net
    speex
    libvorbis
    libogg
    boost
    fribidi
  ];

  sconsFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "INSTALLDIR=${placeholder "out"}/share/globulation2"
    "DATADIR=${placeholder "out"}/share/globulation2/glob2"
  ];

  NIX_LDFLAGS = "-lboost_system";

  meta = with lib; {
    description = "RTS without micromanagement";
    mainProgram = "glob2";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl3;
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
  passthru.updateInfo.downloadPage = "http://globulation2.org/wiki/Download_and_Install";
}
