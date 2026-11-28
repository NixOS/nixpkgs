{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  freetype,
  libxcomposite,
  libxcursor,
  libxext,
  libxinerama,
  libxrender,
  vst2-sdk,
}:

stdenv.mkDerivation {
  __structuredAttrs = true;

  pname = "argotlunar";
  version = "unstable-2026-08-16";

  src = fetchFromGitHub {
    owner = "smootswag";
    repo = "argotlunar";
    rev = "2440c12f02826bd6e563f7287a232997bc1f0313";
    hash = "sha256-pyZV7fzwISAWZzs5A3L2nDJBjoDi1WXongRFCs9F4hg=";
  };

  strictDeps = true;

  buildInputs = [
    alsa-lib
    freetype
    libxcomposite
    libxcursor
    libxext
    libxinerama
    libxrender
    vst2-sdk
  ];

  NIX_CFLAGS_COMPILE = [
    "-fno-strict-aliasing"
    "-Wno-error=packed"
    "-I${vst2-sdk}"
    "-DJUCE_USE_VSTSDK_2_4=1"
    "-DJUCE_FORCE_USE_LEGACY_COMPATIBILITY=1"
    "-DJUCE_PLUGINHOST_VST=1"
    "-DJUCE_MODAL_LOOPS_PERMITTED=1"
  ];

  preBuild = ''
    cd Builds/Linux
  '';

  installPhase = ''
    install -Dm755 build/*.so -t "$out/lib/vst"
  '';

  meta = {
    description = "Argotlunar VST granulizer with modern fixes";
    homepage = "https://github.com/mourednik/argotlunar";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
