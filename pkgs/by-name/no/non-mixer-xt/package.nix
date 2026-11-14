{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
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
    tag = finalAttrs.version;
    # Includes the nonlib/FL submodules this needs, plus the ~24 MB
    # Steinberg VST3 SDK submodules this doesn't (EnableVST3Support is off
    # below) -- not worth hand-fetching nonlib/FL separately and splicing
    # them in just to dodge that extra download.
    fetchSubmodules = true;
    hash = "sha256-Snsk0PCwpjU8w0DmNsjOhgZlrFBrmlCLVBS5NC8/oNM=";
  };

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--help";

  meta = {
    description = "Modular JACK audio mixer with extended LV2, CLAP, VST(2) support (reboot of Non-Mixer)";
    homepage = "https://github.com/Stazed/non-mixer-xt";
    changelog = "https://github.com/Stazed/non-mixer-xt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.rickprice ];
    mainProgram = "non-mixer-xt";
  };
})
