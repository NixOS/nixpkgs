{ stdenv
, lib
, fetchzip
, fetchurl
, runCommandNoCC
, fcft
, freetype
, pixman
, libxkbcommon
, fontconfig
, wayland
, meson
, ninja
, ncurses
, scdoc
, tllist
, wayland-protocols
, pkg-config
, allowPgo ? true
, python3  # for PGO
}:

let
  version = "1.6.2";

  # build stimuli file for PGO build and the script to generate it
  # independently of the foot's build, so we can cache the result
  # and avoid unnecessary rebuilds as it can take relatively long
  # to generate
  stimulusGenerator = stdenv.mkDerivation {
    pname = "foot-generate-alt-random-writes";
    inherit version;

    src = fetchurl {
      url = "https://codeberg.org/dnkl/foot/raw/tag/${version}/scripts/generate-alt-random-writes.py";
      sha256 = "0pnc5nvqrbgx5618ylrkrs9fyxjh4jcsbryfk6vlnk8x4wyyaibz";
    };

    dontUnpack = true;

    buildInputs = [ python3 ];

    installPhase = ''
      install -Dm755 $src $out
    '';
  };

  stimuliFile = runCommandNoCC "pgo-stimulus-file" { } ''
    ${stimulusGenerator} \
      --rows=67 --cols=135 \
      --scroll --scroll-region \
      --colors-regular --colors-bright --colors-256 --colors-rgb \
      --attr-bold --attr-italic --attr-underline \
      --sixel \
      --seed=2305843009213693951 \
      $out
  '';

  compilerName =
    if stdenv.cc.isClang
    then "clang"
    else if stdenv.cc.isGNU
    then "gcc"
    else "unknown";

  # https://codeberg.org/dnkl/foot/src/branch/master/INSTALL.md#performance-optimized-pgo
  pgoCflags = {
    "clang" = "-O3 -Wno-ignored-optimization-argument -Wno-profile-instr-out-of-date -Wno-profile-instr-unprofiled";
    "gcc" = "-O3 -Wno-missing-profile";
  }."${compilerName}";

  # ar with lto support
  ar = {
    "clang" = "llvm-ar";
    "gcc" = "gcc-ar";
    "unknown" = "ar";
  }."${compilerName}";

  # PGO only makes sense if we are not cross compiling and
  # using a compiler which foot's PGO build supports (clang or gcc)
  doPgo = allowPgo && (stdenv.hostPlatform == stdenv.buildPlatform)
    && compilerName != "unknown";
in
stdenv.mkDerivation rec {
  pname = "foot";
  inherit version;

  src = fetchzip {
    url = "https://codeberg.org/dnkl/${pname}/archive/${version}.tar.gz";
    sha256 = "08i3jmjky5s2nnc0c95c009cym91rs4sj4876sr4xnlkb7ab4812";
  };

  nativeBuildInputs = [
    meson
    ninja
    ncurses
    scdoc
    tllist
    wayland-protocols
    pkg-config
  ] ++ lib.optional stdenv.cc.isClang stdenv.cc.cc.llvm;

  buildInputs = [
    fontconfig
    freetype
    pixman
    wayland
    libxkbcommon
    fcft
  ];

  # recommended build flags for performance optimized foot builds
  # https://codeberg.org/dnkl/foot/src/branch/master/INSTALL.md#release-build
  CFLAGS =
    if !doPgo
    then "-O3 -fno-plt"
    else pgoCflags;

  # ar with gcc plugins for lto objects
  preConfigure = ''
    export AR="${ar}"
  '';

  mesonFlags = [ "--buildtype=release" "-Db_lto=true" ];

  # build and run binary generating PGO profiles,
  # then reconfigure to build the normal foot binary utilizing PGO
  preBuild = lib.optionalString doPgo ''
    meson configure -Db_pgo=generate
    ninja
    ./pgo ${stimuliFile} ${stimuliFile} ${stimuliFile}
    meson configure -Db_pgo=use
  '' + lib.optionalString (doPgo && stdenv.cc.cc.pname == "clang") ''
    llvm-profdata merge default_*profraw --output=default.profdata
  '';

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/foot/";
    changelog = "https://codeberg.org/dnkl/foot/releases/tag/${version}";
    description = "A fast, lightweight and minimalistic Wayland terminal emulator";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.linux;
  };
}
