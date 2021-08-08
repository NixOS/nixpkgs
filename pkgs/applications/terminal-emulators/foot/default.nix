{ stdenv
, lib
, fetchFromGitea
, fetchurl
, fetchpatch
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
, wayland-scanner
, pkg-config
, utf8proc
, allowPgo ? true
, python3  # for PGO
# for clang stdenv check
, foot
, llvmPackages
, llvmPackages_latest
}:

let
  version = "1.8.2";

  # build stimuli file for PGO build and the script to generate it
  # independently of the foot's build, so we can cache the result
  # and avoid unnecessary rebuilds as it can take relatively long
  # to generate
  #
  # For every bump, make sure that the hash is still accurate.
  stimulusGenerator = stdenv.mkDerivation {
    pname = "foot-generate-alt-random-writes";
    inherit version;

    src = fetchurl {
      url = "https://codeberg.org/dnkl/foot/raw/tag/${version}/scripts/generate-alt-random-writes.py";
      sha256 = "0w4d0rxi54p8lvbynypcywqqwbbzmyyzc0svjab27ngmdj1034ii";
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
in
stdenv.mkDerivation rec {
  pname = "foot";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = pname;
    rev = version;
    sha256 = "1k0alz991cslls4926c5gq02pdq0vfw9jfpprh2a1vb59xgikv7h";
  };

  patches = [
    # Fixes PGO builds with clang
    (fetchpatch {
      url = "https://codeberg.org/dnkl/foot/commit/2acd4b34c57659d86dca76c58e4363de9b0a1f17.patch";
      sha256 = "13xi9ppaqx2p88cxbh6801ry9ral70ylh40agn6ij7pklybs4d7s";
      includes = [ "pgo/pgo.c" ];
    })
  ];

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

  mesonFlags = [
    "-Db_lto=true"
    "-Dterminfo-install-location=${placeholder "terminfo"}/share/terminfo"
  ];

  # build and run binary generating PGO profiles,
  # then reconfigure to build the normal foot binary utilizing PGO
  preBuild = lib.optionalString doPgo ''
    meson configure -Db_pgo=generate
    ninja
    # make sure there is _some_ profiling data on all binaries
    ./footclient --version
    ./foot --version
    # generate pgo data of wayland independent code
    ./pgo ${stimuliFile} ${stimuliFile} ${stimuliFile}
    meson configure -Db_pgo=use
  '' + lib.optionalString (doPgo && compilerName == "clang") ''
    llvm-profdata merge default_*profraw --output=default.profdata
  '';

  outputs = [ "out" "terminfo" ];

  # make sure nix-env and buildEnv also include the
  # terminfo output when the package is installed
  postInstall = ''
    mkdir -p "$out/nix-support"
    echo "$terminfo" >> "$out/nix-support/propagated-user-env-packages"
  '';

  passthru.tests = {
    clang-default-compilation = foot.override {
      inherit (llvmPackages) stdenv;
    };

    clang-latest-compilation = foot.override {
      inherit (llvmPackages_latest) stdenv;
    };
  };

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/foot/";
    changelog = "https://codeberg.org/dnkl/foot/releases/tag/${version}";
    description = "A fast, lightweight and minimalistic Wayland terminal emulator";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.linux;
  };
}
