{ stdenv
, lib
, fetchFromGitea
, fetchurl
, fetchpatch
, runCommand
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
, wayland-scanner
, pkg-config
, utf8proc
, allowPgo ? !stdenv.hostPlatform.isMusl
, python3  # for PGO
# for clang stdenv check
, foot
, llvmPackages
}:

let
  version = "1.16.2";

  # build stimuli file for PGO build and the script to generate it
  # independently of the foot's build, so we can cache the result
  # and avoid unnecessary rebuilds as it can take relatively long
  # to generate
  #
  # For every bump, make sure that the hash is still accurate.
  stimulusGenerator = stdenv.mkDerivation {
    name = "foot-generate-alt-random-writes";

    src = fetchurl {
      url = "https://codeberg.org/dnkl/foot/raw/tag/${version}/scripts/generate-alt-random-writes.py";
      hash = "sha256-NvkKJ75n/OzgEd2WHX1NQIXPn9R0Z+YI1rpFmNxaDhk=";
    };

    dontUnpack = true;

    buildInputs = [ python3 ];

    installPhase = ''
      install -Dm755 $src $out
    '';
  };

  stimuliFile = runCommand "pgo-stimulus-file" { } ''
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
    "clang" = "-O3 -Wno-ignored-optimization-argument";
    "gcc" = "-O3";
  }."${compilerName}";

  # ar with lto support
  ar = stdenv.cc.bintools.targetPrefix + {
    "clang" = "llvm-ar";
    "gcc" = "gcc-ar";
    "unknown" = "ar";
  }."${compilerName}";

  # PGO only makes sense if we are not cross compiling and
  # using a compiler which foot's PGO build supports (clang or gcc)
  doPgo = allowPgo && (stdenv.hostPlatform == stdenv.buildPlatform)
    && compilerName != "unknown";

  terminfoDir = "${placeholder "terminfo"}/share/terminfo";
in
stdenv.mkDerivation {
  pname = "foot";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "foot";
    rev = version;
    hash = "sha256-hT+btlfqfwGBDWTssYl8KN6SbR9/Y2ors4ipECliigM=";
  };

  separateDebugInfo = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    wayland-scanner
    meson
    ninja
    ncurses
    scdoc
    pkg-config
  ] ++ lib.optionals (compilerName == "clang") [
    stdenv.cc.cc.libllvm.out
  ];

  buildInputs = [
    tllist
    wayland-protocols
    fontconfig
    freetype
    pixman
    wayland
    libxkbcommon
    fcft
    utf8proc
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

  mesonBuildType = "release";

  # See https://codeberg.org/dnkl/foot/src/tag/1.9.2/INSTALL.md#options
  mesonFlags = [
    # Use lto
    "-Db_lto=true"
    # “Build” and install terminfo db
    "-Dterminfo=enabled"
    # Ensure TERM=foot is used
    "-Ddefault-terminfo=foot"
    # Tell foot to set TERMINFO and where to install the terminfo files
    "-Dcustom-terminfo-install-location=${terminfoDir}"
    # Install systemd user units for foot-server
    "-Dsystemd-units-dir=${placeholder "out"}/lib/systemd/user"
  ];

  # build and run binary generating PGO profiles,
  # then reconfigure to build the normal foot binary utilizing PGO
  preBuild = lib.optionalString doPgo ''
    meson configure -Db_pgo=generate
    ninja
    # make sure there is _some_ profiling data on all binaries
    ./footclient --version
    ./foot --version
    ./utils/xtgettcap
    ./tests/test-config
    # generate pgo data of wayland independent code
    ./pgo ${stimuliFile} ${stimuliFile} ${stimuliFile}
    meson configure -Db_pgo=use
  '' + lib.optionalString (doPgo && compilerName == "clang") ''
    llvm-profdata merge default_*profraw --output=default.profdata
  '';

  # Install example themes which can be added to foot.ini via the include
  # directive to a separate output to save a bit of space
  postInstall = ''
    moveToOutput share/foot/themes "$themes"
  '';

  outputs = [ "out" "terminfo" "themes" ];

  passthru.tests = {
    clang-default-compilation = foot.override {
      inherit (llvmPackages) stdenv;
    };

    noPgo = foot.override {
      allowPgo = false;
    };

    # By changing name, this will get rebuilt everytime we change version,
    # even if the hash stays the same. Consequently it'll fail if we introduce
    # a hash mismatch when updating.
    stimulus-script-is-current = stimulusGenerator.src.overrideAttrs (_: {
      name = "generate-alt-random-writes-${version}.py";
    });
  };

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/foot/";
    changelog = "https://codeberg.org/dnkl/foot/releases/tag/${version}";
    description = "A fast, lightweight and minimalistic Wayland terminal emulator";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann maintainers.abbe ];
    platforms = platforms.linux;
    # From (presumably) ncurses version 6.3, it will ship a foot
    # terminfo file. This however won't include some non-standard
    # capabilities foot's bundled terminfo file contains. Unless we
    # want to have some features in e. g. vim or tmux stop working,
    # we need to make sure that the foot terminfo overwrites ncurses'
    # one. Due to <nixpkgs/nixos/modules/config/system-path.nix>
    # ncurses is always added to environment.systemPackages on
    # NixOS with its priority increased by 3, so we need to go
    # one bigger.
    # This doesn't matter a lot for local use since foot sets
    # TERMINFO to a store path, but allows installing foot.terminfo
    # on remote systems for proper foot terminfo support.
    priority = (ncurses.meta.priority or 5) + 3 + 1;
    mainProgram = "foot";
  };
}
