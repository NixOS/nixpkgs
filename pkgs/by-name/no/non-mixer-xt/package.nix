{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  cmake,
  pkg-config,
  fltk,
  libjack2,
  liblo,
  lilv,
  suil,
  lv2,
  serd,
  zix,
  clap,
  ladspa-header,
  lrdf,
  pango,
  cairo,
  libjpeg,
  libpng,
  fontconfig,
  libxfixes,
  libxinerama,
  libxcursor,
  libxext,
  libx11,
  libxft,
  libxrender,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "non-mixer-xt";
  version = "2.0.15";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Stazed";
    repo = "non-mixer-xt";
    tag = "2.0.15";
    hash = "sha256-ynhrlxASOWt3I9VEA1Z8ZkP+h8uMyim3hhy0Qh7V4Nw=";
  };

  # Fetched separately rather than as git submodules so the ~24 MB Steinberg
  # VST3 SDK submodule can be skipped (see EnableVST3Support below) without
  # needing to touch .gitmodules.
  nonlibSrc = fetchFromGitHub {
    owner = "Stazed";
    repo = "nonlib-xt";
    rev = "33b704d638d1383826ea4c36e5607aefabf83371";
    hash = "sha256-RNlKCTn4o2E9h0zXssdyrfretA90MM/aoE5ezG5wpDs=";
  };

  flSrc = fetchFromGitHub {
    owner = "Stazed";
    repo = "non-FL";
    rev = "37158cd7b23d47ab150a82381d7cd3536c473854";
    hash = "sha256-DoEdaQCaohZFQcoaK0HgICQy03IjStD/gPaMbk4rAKA=";
  };

  postUnpack = ''
    rm -rf source/nonlib source/FL
    cp -r --no-preserve=mode,ownership "$nonlibSrc" source/nonlib
    cp -r --no-preserve=mode,ownership "$flSrc" source/FL
  '';

  # nixpkgs' fltk splits cairo support into a separate static lib that
  # upstream's CMakeLists doesn't know to link against.
  postPatch = ''
    substituteInPlace mixer/CMakeLists.txt \
      --replace-fail \
        ' ''${FLTK_STATIC} ''${FLTK_STATIC_IMAGES} ''${ExternLibraries})' \
        ' ''${FLTK_STATIC} ''${FLTK_STATIC_IMAGES} fltk_cairo ''${ExternLibraries})'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    # provides the `fluid` binary that find_package(FLTK) looks for
    fltk
  ];

  buildInputs = [
    fltk
    libjack2
    liblo
    lilv
    suil
    lv2
    serd
    zix
    clap
    ladspa-header
    lrdf
    pango
    cairo
    libjpeg
    libpng
    fontconfig
    libxfixes
    libxinerama
    libxcursor
    libxext
    libx11
    libxft
    libxrender
  ];

  # Bundling Steinberg's VST3 SDK submodule just for this is unnecessary;
  # VST2/LV2/CLAP/LADSPA cover plugin needs without it.
  cmakeFlags = [
    (lib.cmakeBool "EnableVST3Support" false)
    (lib.cmakeBool "NativeOptimizations" false)
  ];

  passthru.tests.help = runCommand "${finalAttrs.pname}-test-help" { } ''
    output="$(${finalAttrs.finalPackage}/bin/non-mixer-xt --help 2>&1)" || true
    [[ "$output" == *"Non-Mixer-XT ${finalAttrs.version}"* ]]
    touch $out
  '';

  meta = {
    description = "Modular JACK audio mixer with extended LV2, CLAP, VST(2) support (reboot of Non-Mixer)";
    homepage = "https://github.com/Stazed/non-mixer-xt";
    changelog = "https://github.com/Stazed/non-mixer-xt/releases/tag/2.0.15";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.rickprice ];
    mainProgram = "non-mixer-xt";
  };
})
