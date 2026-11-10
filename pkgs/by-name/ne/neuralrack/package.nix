{
  alsa-lib,
  cairo,
  fetchFromGitHub,
  lib,
  libjack2,
  libsndfile,
  libx11,
  lv2,
  pkg-config,
  stdenv,
  xorgproto,
  xxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neuralrack";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "NeuralRack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-60b18rAj4Za0H1lzPzvRYQdLFMYCBkKGMmSYJGBOaIQ=";
    fetchSubmodules = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    xxd
  ];

  buildInputs = [
    alsa-lib
    cairo
    libjack2
    libsndfile
    libx11
    lv2
    xorgproto
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "INSTALL_DIR=$(out)/lib/lv2"
    "EXE_INSTALL_DIR=$(out)/bin"
    "CLAP_INSTAL_DIR=$(out)/lib/clap"
    "VST2_INSTAL_DIR=$(out)/lib/vst"
    "VST3_INSTALL_DIR=$(out)/lib/vst3"
    "VST3_INSTAL_DIR=$(out)/lib/vst3"
    "user=root"
    "STRIP=:"
    "HAVE_XXD=1"
  ];

  postPatch = ''
    substituteInPlace NeuralRack/makefile \
      --replace-fail "-flto=auto" "" \
      --replace-fail "pkg-config" '$(PKG_CONFIG)'

    substituteInPlace libxputty/Build/Makefile \
      --replace-fail "pkg-config" '$(PKG_CONFIG)'

    substituteInPlace libxputty/Build/Makefile.base \
      --replace-fail "pkg-config" '$(PKG_CONFIG)'
  '';

  meta = {
    homepage = "https://github.com/brummer10/NeuralRack";
    description = "Neural Model and Impulse Response (IR) File loader";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.linux;
    mainProgram = "Neuralrack";
  };
})
