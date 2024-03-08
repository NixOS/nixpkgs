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
, cage     # for PGO
# for clang stdenv check
, foot
, llvmPackages
}:

let
  version = "1.16.2";

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
  ] ++ lib.optionals doPgo [
    cage
    python3
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

  preConfigure = ''
    patchShebangs --build ./pgo ./scripts

    # ar with gcc plugins for lto objects
    export AR="${ar}"
    # foot needs an UTF-8 locale when executed for PGO
    export LANG=C.UTF-8
    # Eliminate randomness of PGO input data
    echo 'script_options="$script_options --seed=2305843009213693951"' >> ./pgo/options
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


  doCheck = true;

  # build and run all binaries (including tests) generating PGO profiles,
  # then reconfigure to build the normal foot binaries utilizing PGO.
  preBuild = lib.optionalString doPgo ''
    meson configure -Db_pgo=generate
    ninja
    ninja test
    "$NIX_BUILD_TOP/$sourceRoot/pgo/full-headless-cage.sh" "$NIX_BUILD_TOP/$sourceRoot" .
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
