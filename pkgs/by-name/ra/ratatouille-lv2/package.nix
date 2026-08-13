{
  cairo,
  fetchFromGitHub,
  lib,
  libx11,
  libjack2,
  libsndfile,
  lv2,
  pkg-config,
  stdenv,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ratatouille-lv2";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "Ratatouille.lv2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mig3yUGSNz1xuyz6ljKqJUjNqmEcsbXSH1vTxTGdOFk=";
    fetchSubmodules = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libx11
    xorgproto
    cairo
    lv2
    libsndfile
    libjack2
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "INSTALL_DIR=$(out)/lib/lv2"
    "EXE_INSTALL_DIR=$(out)/bin"
    "CLAP_INSTAL_DIR=$(out)/lib/clap"
    "VST2_INSTAL_DIR=$(out)/lib/vst"
    "user=root"
    "STRIP=:"
  ];

  postPatch = ''
    substituteInPlace Ratatouille/makefile \
      --replace-fail "-flto=auto" ""
  '';

  meta = {
    homepage = "https://github.com/brummer10/Ratatouille.lv2";
    description = "Neural Amp Modeler LV2 plugin";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.linux;
    mainProgram = "Ratatouille";
  };
})
