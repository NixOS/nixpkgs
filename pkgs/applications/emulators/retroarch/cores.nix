{ lib
, stdenv
, alsa-lib
, boost
, bzip2
, cmake
, curl
, fetchFromGitHub
, ffmpeg
, ffmpeg_4
, fluidsynth
, gettext
, hexdump
, hidapi
, icu
, libaio
, libevdev
, libGL
, libGLU
, libjpeg
, libpcap
, libpng
, libvorbis
, libxml2
, libzip
, makeWrapper
, nasm
, openssl
, pcre
, pkg-config
, portaudio
, python3
, retroarch
, sfml
, snappy
, udev
, which
, xorg
, xxd
, xz
, zlib
}:

let
  hashesFile = lib.importJSON ./hashes.json;

  getCoreSrc = core:
    fetchFromGitHub (builtins.getAttr core hashesFile);

  mkLibretroCore =
    { core
    , src ? (getCoreSrc core)
    , version ? "unstable-2023-09-24"
    , ...
    }@args:
    import ./mkLibretroCore.nix ({
      inherit lib stdenv core src version makeWrapper retroarch zlib;
    } // args);
in
{
  inherit mkLibretroCore;

  atari800 = mkLibretroCore {
    core = "atari800";
    makefile = "Makefile";
    makeFlags = [ "GIT_VERSION=" ];
    meta = {
      description = "Port of Atari800 to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-gba = mkLibretroCore {
    core = "mednafen-gba";
    src = getCoreSrc "beetle-gba";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's GameBoy Advance core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-lynx = mkLibretroCore {
    core = "mednafen-lynx";
    src = getCoreSrc "beetle-lynx";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's Lynx core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-ngp = mkLibretroCore {
    core = "mednafen-ngp";
    src = getCoreSrc "beetle-ngp";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's NeoGeo Pocket core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-pce = mkLibretroCore {
    core = "mednafen-pce";
    src = getCoreSrc "beetle-pce";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's PC Engine core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-pce-fast = mkLibretroCore {
    core = "mednafen-pce-fast";
    src = getCoreSrc "beetle-pce-fast";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's PC Engine fast core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-pcfx = mkLibretroCore {
    core = "mednafen-pcfx";
    src = getCoreSrc "beetle-pcfx";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's PCFX core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-psx = mkLibretroCore {
    core = "mednafen-psx";
    src = getCoreSrc "beetle-psx";
    makefile = "Makefile";
    makeFlags = [ "HAVE_HW=0" "HAVE_LIGHTREC=1" ];
    meta = {
      description = "Port of Mednafen's PSX Engine core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-psx-hw = mkLibretroCore {
    core = "mednafen-psx-hw";
    src = getCoreSrc "beetle-psx";
    extraBuildInputs = [ libGL libGLU ];
    makefile = "Makefile";
    makeFlags = [ "HAVE_VULKAN=1" "HAVE_OPENGL=1" "HAVE_HW=1" "HAVE_LIGHTREC=1" ];
    meta = {
      description = "Port of Mednafen's PSX Engine (with HW accel) core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-saturn = mkLibretroCore {
    core = "mednafen-saturn";
    src = getCoreSrc "beetle-saturn";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's Saturn core to libretro";
      license = lib.licenses.gpl2Only;
      platforms = [ "aarch64-linux" "x86_64-linux" ];
    };
  };

  beetle-supafaust = mkLibretroCore {
    core = "mednafen-supafaust";
    src = getCoreSrc "beetle-supafaust";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's experimental snes_faust core to libretro";
      license = lib.licenses.gpl2Plus;
    };
  };

  beetle-supergrafx = mkLibretroCore {
    core = "mednafen-supergrafx";
    src = getCoreSrc "beetle-supergrafx";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's SuperGrafx core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-vb = mkLibretroCore {
    core = "mednafen-vb";
    src = getCoreSrc "beetle-vb";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's VirtualBoy core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  beetle-wswan = mkLibretroCore {
    core = "mednafen-wswan";
    src = getCoreSrc "beetle-wswan";
    makefile = "Makefile";
    meta = {
      description = "Port of Mednafen's WonderSwan core to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  blastem = mkLibretroCore {
    core = "blastem";
    meta = {
      description = "Port of BlastEm to libretro";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.x86;
    };
  };

  bluemsx = mkLibretroCore {
    core = "bluemsx";
    meta = {
      description = "Port of BlueMSX to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  bsnes = mkLibretroCore {
    core = "bsnes";
    makefile = "Makefile";
    meta = {
      description = "Port of bsnes to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  bsnes-hd = mkLibretroCore {
    core = "bsnes-hd-beta";
    src = getCoreSrc "bsnes-hd";
    makefile = "GNUmakefile";
    makeFlags =
      let
        # linux = bsd
        # https://github.com/DerKoun/bsnes-hd/blob/f0b6cf34e9780d53516977ed2de64137a8bcc3c5/bsnes/GNUmakefile#L37
        platform = if stdenv.isDarwin then "macos" else "linux";
      in
      [
        "-C"
        "bsnes"
        "target=libretro"
        "platform=${platform}"
      ];
    extraBuildInputs = [ xorg.libX11 xorg.libXext ];
    postBuild = "cd bsnes/out";
    meta = {
      description = "Port of bsnes-hd to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  bsnes-mercury = mkLibretroCore {
    core = "bsnes-mercury-accuracy";
    src = getCoreSrc "bsnes-mercury";
    makefile = "Makefile";
    makeFlags = [ "PROFILE=accuracy" ];
    meta = {
      description = "Fork of bsnes with HLE DSP emulation restored (accuracy profile)";
      license = lib.licenses.gpl3Only;
    };
  };

  bsnes-mercury-balanced = mkLibretroCore {
    core = "bsnes-mercury-balanced";
    src = getCoreSrc "bsnes-mercury";
    makefile = "Makefile";
    makeFlags = [ "PROFILE=balanced" ];
    meta = {
      description = "Fork of bsnes with HLE DSP emulation restored (balanced profile)";
      license = lib.licenses.gpl3Only;
    };
  };

  bsnes-mercury-performance = mkLibretroCore {
    core = "bsnes-mercury-performance";
    src = getCoreSrc "bsnes-mercury";
    makefile = "Makefile";
    makeFlags = [ "PROFILE=performance" ];
    meta = {
      description = "Fork of bsnes with HLE DSP emulation restored (performance profile)";
      license = lib.licenses.gpl3Only;
    };
  };

  citra = mkLibretroCore {
    core = "citra";
    extraBuildInputs = [ libGLU libGL boost ffmpeg nasm ];
    makefile = "Makefile";
    makeFlags = [
      "HAVE_FFMPEG_STATIC=0"
      # https://github.com/libretro/citra/blob/1a66174355b5ed948de48ef13c0ed508b6d6169f/Makefile#L90
      "BUILD_DATE=01/01/1970_00:00"
    ];
    meta = {
      description = "Port of Citra to libretro";
      license = lib.licenses.gpl2Plus;
    };
  };

  desmume = mkLibretroCore {
    core = "desmume";
    preBuild = "cd desmume/src/frontend/libretro";
    extraBuildInputs = [ libpcap libGLU libGL xorg.libX11 ];
    makeFlags = lib.optional stdenv.hostPlatform.isAarch32 "platform=armv-unix"
      ++ lib.optional (!stdenv.hostPlatform.isx86) "DESMUME_JIT=0";
    meta = {
      description = "Port of DeSmuME to libretro";
      license = lib.licenses.gpl2Plus;
    };
  };

  desmume2015 = mkLibretroCore {
    core = "desmume2015";
    extraBuildInputs = [ libpcap libGLU libGL xorg.libX11 ];
    makeFlags = lib.optional stdenv.hostPlatform.isAarch32 "platform=armv-unix"
      ++ lib.optional (!stdenv.hostPlatform.isx86) "DESMUME_JIT=0";
    preBuild = "cd desmume";
    meta = {
      description = "Port of DeSmuME ~2015 to libretro";
      license = lib.licenses.gpl2Plus;
    };
  };

  dolphin = mkLibretroCore {
    core = "dolphin";
    extraNativeBuildInputs = [ cmake curl pkg-config ];
    extraBuildInputs = [
      libGLU
      libGL
      pcre
      sfml
      gettext
      hidapi
      libevdev
      udev
    ] ++ (with xorg; [ libSM libX11 libXi libpthreadstubs libxcb xcbutil libXext libXrandr libXinerama libXxf86vm ]);
    makefile = "Makefile";
    cmakeFlags = [
      "-DLIBRETRO=ON"
      "-DLIBRETRO_STATIC=1"
      "-DENABLE_QT=OFF"
      "-DENABLE_LTO=OFF"
      "-DUSE_UPNP=OFF"
      "-DUSE_DISCORD_PRESENCE=OFF"
    ];
    dontUseCmakeBuildDir = true;
    meta = {
      description = "Port of Dolphin to libretro";
      license = lib.licenses.gpl2Plus;
    };
  };

  dosbox = mkLibretroCore {
    core = "dosbox";
    CXXFLAGS = "-std=gnu++11";
    meta = {
      description = "Port of DOSBox to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  dosbox-pure = mkLibretroCore {
    core = "dosbox-pure";
    CXXFLAGS = "-std=gnu++11";
    hardeningDisable = [ "format" ];
    makefile = "Makefile";
    meta = {
      description = "Port of DOSBox to libretro aiming for simplicity and ease of use.";
      license = lib.licenses.gpl2Only;
    };
  };

  eightyone = mkLibretroCore {
    core = "81";
    src = getCoreSrc "eightyone";
    meta = {
      description = "Port of EightyOne to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  fbalpha2012 = mkLibretroCore {
    core = "fbalpha2012";
    makefile = "makefile.libretro";
    preBuild = "cd svn-current/trunk";
    meta = {
      description = "Port of Final Burn Alpha ~2012 to libretro";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  fbneo = mkLibretroCore {
    core = "fbneo";
    makefile = "Makefile";
    preBuild = "cd src/burner/libretro";
    meta = {
      description = "Port of FBNeo to libretro";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  fceumm = mkLibretroCore {
    core = "fceumm";
    meta = {
      description = "FCEUmm libretro port";
      license = lib.licenses.gpl2Only;
    };
  };

  flycast = mkLibretroCore {
    core = "flycast";
    extraNativeBuildInputs = [ cmake ];
    extraBuildInputs = [ libGL libGLU ];
    cmakeFlags = [ "-DLIBRETRO=ON" ];
    makefile = "Makefile";
    meta = {
      description = "Flycast libretro port";
      license = lib.licenses.gpl2Only;
      platforms = [ "aarch64-linux" "x86_64-linux" ];
    };
  };

  fmsx = mkLibretroCore {
    core = "fmsx";
    makefile = "Makefile";
    meta = {
      description = "FMSX libretro port";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  freeintv = mkLibretroCore {
    core = "freeintv";
    makefile = "Makefile";
    meta = {
      description = "FreeIntv libretro port";
      license = lib.licenses.gpl3Only;
    };
  };

  fuse = mkLibretroCore {
    core = "fuse";
    meta = {
      description = "A port of the Fuse Unix Spectrum Emulator to libretro";
      license = lib.licenses.gpl3Only;
    };
  };

  gambatte = mkLibretroCore {
    core = "gambatte";
    meta = {
      description = "Gambatte libretro port";
      license = lib.licenses.gpl2Only;
    };
  };

  genesis-plus-gx = mkLibretroCore {
    core = "genesis-plus-gx";
    meta = {
      description = "Enhanced Genesis Plus libretro port";
      # Non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  gpsp = mkLibretroCore {
    core = "gpsp";
    makefile = "Makefile";
    meta = {
      description = "Port of gpSP to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  gw = mkLibretroCore {
    core = "gw";
    makefile = "Makefile";
    meta = {
      description = "Port of Game and Watch to libretro";
      license = lib.licenses.zlib;
    };
  };

  handy = mkLibretroCore {
    core = "handy";
    makefile = "Makefile";
    meta = {
      description = "Port of Handy to libretro";
      license = lib.licenses.zlib;
    };
  };

  hatari = mkLibretroCore {
    core = "hatari";
    extraNativeBuildInputs = [ which ];
    dontConfigure = true;
    # zlib is already included in mkLibretroCore as buildInputs
    makeFlags = [ "EXTERNAL_ZLIB=1" ];
    meta = {
      description = "Port of Hatari to libretro";
      license = lib.licenses.gpl2Only;
    };
  };

  mame = mkLibretroCore {
    core = "mame";
    extraNativeBuildInputs = [ python3 ];
    extraBuildInputs = [ alsa-lib libGLU libGL ];
    # Setting this is breaking compilation of src/3rdparty/genie for some reason
    makeFlags = [ "ARCH=" ];
    meta = {
      description = "Port of MAME to libretro";
      license = with lib.licenses; [ bsd3 gpl2Plus ];
    };
  };

  mame2000 = mkLibretroCore {
    core = "mame2000";
    makefile = "Makefile";
    makeFlags = lib.optional (!stdenv.hostPlatform.isx86) "IS_X86=0";
    meta = {
      description = "Port of MAME ~2000 to libretro, compatible with MAME 0.37b5 sets";
      # MAME license, non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  mame2003 = mkLibretroCore {
    core = "mame2003";
    makefile = "Makefile";
    meta = {
      description = "Port of MAME ~2003 to libretro, compatible with MAME 0.78 sets";
      # MAME license, non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  mame2003-plus = mkLibretroCore {
    core = "mame2003-plus";
    makefile = "Makefile";
    meta = {
      description = "Port of MAME ~2003+ to libretro, compatible with MAME 0.78 sets";
      # MAME license, non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  mame2010 = mkLibretroCore {
    core = "mame2010";
    makefile = "Makefile";
    makeFlags = lib.optionals stdenv.hostPlatform.isAarch64 [ "PTR64=1" "ARM_ENABLED=1" "X86_SH2DRC=0" "FORCE_DRC_C_BACKEND=1" ];
    meta = {
      description = "Port of MAME ~2010 to libretro, compatible with MAME 0.139 sets";
      # MAME license, non-commercial clause
      license = lib.licenses.unfreeRedistributable;
    };
  };

  mame2015 = mkLibretroCore {
    core = "mame2015";
    patches = [ ./patches/mame2015-python311.patch ];
    makeFlags = [ "PYTHON=python3" ];
    extraNativeBuildInputs = [ python3 ];
    extraBuildInputs = [ alsa-lib ];
    makefile = "Makefile";
    enableParallelBuilding = false;
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
    enableParallelBuilding = false;
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

  mupen64plus = mkLibretroCore {
    core = "mupen64plus-next";
    src = getCoreSrc "mupen64plus";
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
    src = getCoreSrc core;
    makeFlags = [
      # See https://github.com/AZO234/NP2kai/tags
      "NP2KAI_VERSION=rev.22"
      "NP2KAI_HASH=${src.rev}"
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
      description = "Parallel Mupen64plus rewrite for libretro.";
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
    cmakeFlags = [
      "-DLIBRETRO=ON"
    ];
    postPatch = ''
      # remove ccache
      substituteInPlace CMakeLists.txt --replace "ccache" ""
    '';

    # causes redefinition of _FORTIFY_SOURCE
    hardeningDisable = [ "fortify3" ];

    postBuild = "cd pcsx2";
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
    meta = {
      description = "Port of Play! to libretro";
      license = lib.licenses.bsd2;
    };
  };

  ppsspp = mkLibretroCore {
    core = "ppsspp";
    extraNativeBuildInputs = [ cmake pkg-config python3 ];
    extraBuildInputs = [ libGLU libGL libzip ffmpeg_4 snappy xorg.libX11 ];
    makefile = "Makefile";
    cmakeFlags = [
      "-DLIBRETRO=ON"
      "-DUSE_SYSTEM_FFMPEG=ON"
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
    src = getCoreSrc "smsplus-gx";
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
    src = getCoreSrc "snes9x2005";
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
    src = getCoreSrc "vba-m";
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
}
