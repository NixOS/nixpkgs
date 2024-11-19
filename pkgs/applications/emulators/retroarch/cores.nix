{ lib
, newScope
, stdenv
, gcc12Stdenv
, alsa-lib
, boost
, bzip2
, cmake
, curl
, fetchFromGitHub
, fetchpatch
, ffmpeg_6
, fluidsynth
, fmt
, freetype
, gettext
, harfbuzz
, hexdump
, hidapi
, icu
, libaio
, libevdev
, libGL
, libGLU
, libjpeg
, liblcf
, libpcap
, libpng
, libsndfile
, libvorbis
, libxml2
, libxmp
, libzip
, mpg123
, nasm
, openssl
, opusfile
, pcre
, pixman
, pkg-config
, portaudio
, python3
, sfml
, snappy
, speexdsp
, udev
, which
, xorg
, xxd
, xz
}:

let
  hashesFile = lib.importJSON ./hashes.json;

  getCore = repo: (lib.getAttr repo hashesFile);

  getCoreSrc = repo:
    let
      inherit (getCore repo) src fetcher;
      fetcherFn = {
        inherit fetchFromGitHub;
      }.${fetcher} or (throw "Unknown fetcher: ${fetcher}");
    in
    fetcherFn src;

  getCoreVersion = repo: (getCore repo).version;
in
lib.makeScope newScope (self: rec {
  mkLibretroCore =
    # Sometimes core name != repo name, so you may need to set them differently
    # when necessary:
    # - core: used by the resulting core library name, e.g.:
    #   `${core}_libretro.so`. Needs to match their respectful core info file
    #   (see https://github.com/libretro/libretro-core-info/)
    # - repo: the repository name on GitHub
    # See `update_cores.py` for instruction on how to add a new core.
    { core
    , repo ? core
    , src ? (getCoreSrc repo)
    , version ? (getCoreVersion repo)
    , ...
    }@args:
    self.callPackage ./mkLibretroCore.nix ({
      inherit core repo src version;
    } // args);

  atari800 = self.callPackage ./cores/atari800.nix { };

  beetle-gba = self.callPackage ./cores/beetle-gba.nix { };

  beetle-lynx = self.callPackage ./cores/beetle-lynx.nix { };

  beetle-ngp = self.callPackage ./cores/beetle-ngp.nix { };

  beetle-pce = self.callPackage ./cores/beetle-pce.nix { };

  beetle-pce-fast = self.callPackage ./cores/beetle-pce-fast.nix { };

  beetle-pcfx = self.callPackage ./cores/beetle-pcfx.nix { };

  beetle-psx = self.callPackage ./cores/beetle-psx.nix { };

  beetle-psx-hw = self.beetle-psx.override { withHw = true; };

  beetle-saturn = self.callPackage ./cores/beetle-saturn.nix { };

  beetle-supafaust = self.callPackage ./cores/beetle-supafaust.nix { };

  beetle-supergrafx = self.callPackage ./cores/beetle-supergrafx.nix { };

  beetle-vb = self.callPackage ./cores/beetle-vb.nix { };

  beetle-wswan = self.callPackage ./cores/beetle-wswan.nix { };

  blastem = self.callPackage ./cores/blastem.nix { };

  bluemsx = self.callPackage ./cores/bluemsx.nix { };

  bsnes = self.callPackage ./cores/bsnes.nix { };

  bsnes-hd = self.callPackage ./cores/bsnes-hd.nix { };

  bsnes-mercury = self.callPackage ./cores/bsnes-mercury.nix { };

  bsnes-mercury-balanced = self.bsnes-mercury.override { withProfile = "balanced"; };

  bsnes-mercury-performance = self.bsnes-mercury.override { withProfile = "performance"; };

  citra = self.callPackage ./cores/citra.nix {  };

  desmume = self.callPackage ./cores/desmume.nix {  };

  desmume2015 = self.callPackage ./cores/desmume2015.nix {  };

  dolphin = self.callPackage ./cores/dolphin.nix {  };

  dosbox = self.callPackage ./cores/dosbox.nix {  };

  dosbox-pure = self.callPackage ./cores/dosbox-pure.nix {  };

  easyrpg = self.callPackage ./cores/easyrpg.nix {  };

  eightyone = self.callPackage ./cores/eightyone.nix {  };

  fbalpha2012 = self.callPackage ./cores/fbalpha2012.nix {  };

  fbneo = self.callPackage ./cores/fbneo.nix {  };

  fceumm = self.callPackage ./cores/fceumm.nix {  };

  flycast = self.callPackage ./cores/flycast.nix {  };

  fmsx = self.callPackage ./cores/fmsx.nix {  };

  freeintv = self.callPackage ./cores/freeintv.nix {  };

  fuse = self.callPackage ./cores/fuse.nix {  };

  gambatte = self.callPackage ./cores/gambatte.nix {  };

  genesis-plus-gx = self.callPackage ./cores/genesis-plus-gx.nix {  };

  gpsp = self.callPackage ./cores/gpsp.nix {  };

  gw = self.callPackage ./cores/gw.nix {  };

  handy = self.callPackage ./cores/handy.nix {  };

  hatari = self.callPackage ./cores/hatari.nix {  };

  mame = self.callPackage ./cores/mame.nix {  };

  mame2000 = self.callPackage ./cores/mame2000.nix {  };

  mame2003 = self.callPackage ./cores/mame2003.nix {  };

  mame2003-plus = self.callPackage ./cores/mame2003-plus.nix {  };

  mame2010 = self.callPackage ./cores/mame2010.nix {  };

  mame2015 = mkLibretroCore {
    core = "mame2015";
    patches = [ ./patches/mame2015-python311.patch ];
    makeFlags = [ "PYTHON=python3" ];
    extraNativeBuildInputs = [ python3 ];
    extraBuildInputs = [ alsa-lib ];
    makefile = "Makefile";
    # Build failures when this is set to a bigger number
    NIX_BUILD_CORES = 8;
    meta = {
      description = "Port of MAME ~2015 to libretro, compatible with MAME 0.160 sets";
      # MAME license, non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  mame2016 = mkLibretroCore {
    core = "mame2016";
    patches = [ ./patches/mame2016-python311.patch ];
    extraNativeBuildInputs = [ python3 ];
    extraBuildInputs = [ alsa-lib ];
    makeFlags = [ "PYTHON_EXECUTABLE=python3" ];
    # Build failures when this is set to a bigger number
    NIX_BUILD_CORES = 8;
    # Fix build errors in GCC13
    NIX_CFLAGS_COMPILE = "-Wno-error -fpermissive";
    meta = {
      description = "Port of MAME ~2016 to libretro, compatible with MAME 0.174 sets";
      license = with lib.licenses; [ bsd3 gpl2Plus ];
    };
  };

  melonds = mkLibretroCore {
    core = "melonds";
    extraBuildInputs = [ libGL libGLU ];
    makefile = "Makefile";
    meta = {
      description = "Port of MelonDS to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  mesen = mkLibretroCore {
    core = "mesen";
    makefile = "Makefile";
    preBuild = "cd Libretro";
    meta = {
      description = "Port of Mesen to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  mesen-s = mkLibretroCore {
    core = "mesen-s";
    makefile = "Makefile";
    preBuild = "cd Libretro";
    normalizeCore = false;
    meta = {
      description = "Port of Mesen-S to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  meteor = mkLibretroCore {
    core = "meteor";
    makefile = "Makefile";
    preBuild = "cd libretro";
    meta = {
      description = "Port of Meteor to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  mgba = mkLibretroCore {
    core = "mgba";
    meta = {
      description = "Port of mGBA to libretro";
      license = lib.licenses.mpl20;
    };
  };

  mrboom = mkLibretroCore {
    core = "mrboom";
    makefile = "Makefile";
    meta = {
      description = "Port of Mr.Boom to libretro";
      license = lib.licenses.mit;
    };
  };

  mupen64plus = mkLibretroCore {
    core = "mupen64plus-next";
    repo = "mupen64plus";
    extraBuildInputs = [ libGLU libGL libpng nasm xorg.libX11 ];
    makefile = "Makefile";
    makeFlags = [
      "HAVE_PARALLEL_RDP=1"
      "HAVE_PARALLEL_RSP=1"
      "HAVE_THR_AL=1"
      "LLE=1"
      "WITH_DYNAREC=${stdenv.hostPlatform.parsed.cpu.name}"
    ];
    meta = {
      description = "Libretro port of Mupen64 Plus, GL only";
      license = lib.licenses.gpl3Only;
    };
  };

  neocd = mkLibretroCore {
    core = "neocd";
    makefile = "Makefile";
    meta = {
      description = "NeoCD libretro port";
      license = lib.licenses.lgpl3Only;
    };
  };

  nestopia = mkLibretroCore {
    core = "nestopia";
    makefile = "Makefile";
    preBuild = "cd libretro";
    meta = {
      description = "Nestopia libretro port";
      license = lib.licenses.gpl2Only;
    };
  };

  nxengine = mkLibretroCore {
    core = "nxengine";
    makefile = "Makefile";
    meta = {
      description = "NXEngine libretro port";
      license = lib.licenses.gpl3Only;
    };
  };

  np2kai = mkLibretroCore rec {
    core = "np2kai";
    makeFlags = [
      # See https://github.com/AZO234/NP2kai/tags
      "NP2KAI_VERSION=rev.22"
      "NP2KAI_HASH=${(getCoreSrc core).rev}"
    ];
    preBuild = "cd sdl";
    meta = {
      description = "Neko Project II kai libretro port";
      license = lib.licenses.mit;
    };
  };

  o2em = mkLibretroCore {
    core = "o2em";
    makefile = "Makefile";
    meta = {
      description = "Port of O2EM to libretro";
      license = lib.licenses.artistic1;
    };
  };

  opera = mkLibretroCore {
    core = "opera";
    makefile = "Makefile";
    makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];
    meta = {
      description = "Opera is a port of 4DO/libfreedo to libretro";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  parallel-n64 = mkLibretroCore {
    core = "parallel-n64";
    extraBuildInputs = [ libGLU libGL libpng ];
    makefile = "Makefile";
    makeFlags = [
      "HAVE_PARALLEL=1"
      "HAVE_PARALLEL_RSP=1"
      "ARCH=${stdenv.hostPlatform.parsed.cpu.name}"
    ];
    postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
      sed -i -e '1 i\CPUFLAGS += -DARM_FIX -DNO_ASM -DARM_ASM -DDONT_WANT_ARM_OPTIMIZATIONS -DARM64' Makefile \
      && sed -i -e 's,CPUFLAGS  :=,,g' Makefile
    '';
    meta = {
      description = "Parallel Mupen64plus rewrite for libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  pcsx2 = mkLibretroCore {
    core = "pcsx2";
    extraNativeBuildInputs = [
      cmake
      gettext
      pkg-config
    ];
    extraBuildInputs = [
      libaio
      libGL
      libGLU
      libpcap
      libpng
      libxml2
      xz
      xxd
    ];
    makefile = "Makefile";
    cmakeFlags = [ "-DLIBRETRO=ON" ];
    # remove ccache
    postPatch = ''
      substituteInPlace CMakeLists.txt --replace "ccache" ""
    '';
    postBuild = "cd pcsx2";
    # causes redefinition of _FORTIFY_SOURCE
    hardeningDisable = [ "fortify3" ];
    # FIXME: multiple build errors with GCC13.
    # Unlikely to be fixed until we switch to libretro/pcsx2 that is a more
    # up-to-date port (but still WIP).
    stdenv = gcc12Stdenv;
    meta = {
      description = "Port of PCSX2 to libretro";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.x86;
    };
  };

  pcsx-rearmed = mkLibretroCore {
    core = "pcsx_rearmed";
    dontConfigure = true;
    meta = {
      description = "Port of PCSX ReARMed with GNU lightning to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  picodrive = mkLibretroCore {
    core = "picodrive";
    dontConfigure = true;
    meta = {
      description = "Fast MegaDrive/MegaCD/32X emulator";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  play = mkLibretroCore {
    core = "play";
    extraBuildInputs = [ boost bzip2 curl openssl icu libGL libGLU xorg.libX11 ];
    extraNativeBuildInputs = [ cmake ];
    makefile = "Makefile";
    cmakeFlags = [ "-DBUILD_PLAY=OFF" "-DBUILD_LIBRETRO_CORE=ON" ];
    postBuild = "cd Source/ui_libretro";
    # FIXME: workaround the following GCC 13 error:
    # error: 'printf' was not declared in this scop
    CXXFLAGS = "-include cstdio";
    meta = {
      description = "Port of Play! to libretro";
      license = lib.licenses.bsd2;
    };
  };

  ppsspp = mkLibretroCore {
    core = "ppsspp";
    extraNativeBuildInputs = [ cmake pkg-config python3 ];
    extraBuildInputs = [ libGLU libGL libzip snappy xorg.libX11 ];
    makefile = "Makefile";
    cmakeFlags = [
      "-DLIBRETRO=ON"
      # USE_SYSTEM_FFMPEG=ON causes several glitches during video playback
      # See: https://github.com/NixOS/nixpkgs/issues/304616
      "-DUSE_SYSTEM_FFMPEG=OFF"
      "-DUSE_SYSTEM_SNAPPY=ON"
      "-DUSE_SYSTEM_LIBZIP=ON"
      "-DOpenGL_GL_PREFERENCE=GLVND"
    ];
    postBuild = "cd lib";
    meta = {
      description = "ppsspp libretro port";
      license = lib.licenses.gpl2Plus;
    };
  };

  prboom = mkLibretroCore {
    core = "prboom";
    makefile = "Makefile";
    meta = {
      description = "Prboom libretro port";
      license = lib.licenses.gpl2Only;
    };
  };

  prosystem = mkLibretroCore {
    core = "prosystem";
    makefile = "Makefile";
    meta = {
      description = "Port of ProSystem to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  puae = mkLibretroCore {
    core = "puae";
    makefile = "Makefile";
    meta = {
      description = "Amiga emulator based on WinUAE";
      license = lib.licenses.gpl2Only;
    };
  };

  quicknes = mkLibretroCore {
    core = "quicknes";
    makefile = "Makefile";
    meta = {
      description = "QuickNES libretro port";
      license = lib.licenses.lgpl21Plus;
    };
  };

  sameboy = mkLibretroCore {
    core = "sameboy";
    extraNativeBuildInputs = [ which hexdump ];
    preBuild = "cd libretro";
    makefile = "Makefile";
    meta = {
      description = "SameBoy libretro port";
      license = lib.licenses.mit;
    };
  };

  same_cdi = mkLibretroCore {
    core = "same_cdi";
    extraNativeBuildInputs = [ python3 ];
    extraBuildInputs = [ alsa-lib libGLU libGL portaudio xorg.libX11 ];
    # FIXME: build fail with GCC13:
    # error: 'uint8_t' in namespace 'std' does not name a type; did you mean 'wint_t'?
    stdenv = gcc12Stdenv;
    meta = {
      description = "SAME_CDI is a libretro core to play CD-i games";
      license = with lib.licenses; [ bsd3 gpl2Plus ];
    };
  };

  scummvm = mkLibretroCore {
    core = "scummvm";
    extraBuildInputs = [ fluidsynth libjpeg libvorbis libGLU libGL ];
    makefile = "Makefile";
    preConfigure = "cd backends/platform/libretro/build";
    meta = {
      description = "Libretro port of ScummVM";
      license = lib.licenses.gpl2Only;
    };
  };

  smsplus-gx = mkLibretroCore {
    core = "smsplus";
    repo = "smsplus-gx";
    meta = {
      description = "SMS Plus GX libretro port";
      license = lib.licenses.gpl2Plus;
    };
  };

  snes9x = mkLibretroCore {
    core = "snes9x";
    makefile = "Makefile";
    preBuild = "cd libretro";
    meta = {
      description = "Port of SNES9x git to libretro";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  snes9x2002 = mkLibretroCore {
    core = "snes9x2002";
    makefile = "Makefile";
    meta = {
      description = "Optimized port/rewrite of SNES9x 1.39 to Libretro";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  snes9x2005 = mkLibretroCore {
    core = "snes9x2005";
    makefile = "Makefile";
    meta = {
      description = "Optimized port/rewrite of SNES9x 1.43 to Libretro";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  snes9x2005-plus = mkLibretroCore {
    core = "snes9x2005-plus";
    repo = "snes9x2005";
    makefile = "Makefile";
    makeFlags = [ "USE_BLARGG_APU=1" ];
    meta = {
      description = "Optimized port/rewrite of SNES9x 1.43 to Libretro, with Blargg's APU";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  snes9x2010 = mkLibretroCore {
    core = "snes9x2010";
    meta = {
      description = "Optimized port/rewrite of SNES9x 1.52+ to Libretro";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  stella = mkLibretroCore {
    core = "stella";
    makefile = "Makefile";
    preBuild = "cd src/os/libretro";
    dontConfigure = true;
    meta = {
      description = "Port of Stella to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  stella2014 = mkLibretroCore {
    core = "stella2014";
    makefile = "Makefile";
    meta = {
      description = "Port of Stella ~2014 to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  swanstation = mkLibretroCore {
    core = "swanstation";
    extraNativeBuildInputs = [ cmake ];
    makefile = "Makefile";
    cmakeFlags = [
      "-DBUILD_LIBRETRO_CORE=ON"
    ];
    meta = {
      description = "Port of SwanStation (a fork of DuckStation) to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  tgbdual = mkLibretroCore {
    core = "tgbdual";
    makefile = "Makefile";
    meta = {
      description = "Port of TGBDual to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  thepowdertoy = mkLibretroCore {
    core = "thepowdertoy";
    extraNativeBuildInputs = [ cmake ];
    makefile = "Makefile";
    postBuild = "cd src";
    meta = {
      description = "Port of The Powder Toy to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  tic80 = mkLibretroCore {
    core = "tic80";
    extraNativeBuildInputs = [ cmake pkg-config ];
    makefile = "Makefile";
    cmakeFlags = [
      "-DBUILD_LIBRETRO=ON"
      "-DBUILD_DEMO_CARTS=OFF"
      "-DBUILD_PRO=OFF"
      "-DBUILD_PLAYER=OFF"
      "-DBUILD_SDL=OFF"
      "-DBUILD_SOKOL=OFF"
    ];
    preConfigure = "cd core";
    postBuild = "cd lib";
    meta = {
      description = "Port of TIC-80 to libretro";
      license = lib.licenses.mit;
    };
  };

  twenty-fortyeight = mkLibretroCore {
    core = "2048";
    meta = {
      description = "Port of 2048 puzzle game to the libretro API";
      license = lib.licenses.unlicense;
    };
  };

  vba-m = mkLibretroCore {
    core = "vbam";
    repo = "vba-m";
    makefile = "Makefile";
    preBuild = "cd src/libretro";
    meta = {
      description = "vanilla VBA-M libretro port";
      license = lib.licenses.gpl2Only;
    };
  };

  vba-next = mkLibretroCore {
    core = "vba-next";
    meta = {
      description = "VBA-M libretro port with modifications for speed";
      license = lib.licenses.gpl2Only;
    };
  };

  vecx = mkLibretroCore {
    core = "vecx";
    extraBuildInputs = [ libGL libGLU ];
    meta = {
      description = "Port of Vecx to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  virtualjaguar = mkLibretroCore {
    core = "virtualjaguar";
    makefile = "Makefile";
    meta = {
      description = "Port of VirtualJaguar to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  yabause = mkLibretroCore {
    core = "yabause";
    makefile = "Makefile";
    # Disable SSE for non-x86. DYNAREC doesn't build on aarch64.
    makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "HAVE_SSE=0";
    preBuild = "cd yabause/src/libretro";
    meta = {
      description = "Port of Yabause to libretro";
      license = lib.licenses.gpl2Only;
    };
  };
})
