{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  wafHook,
  libbs2b,
  lv2,
}:

stdenv.mkDerivation rec {
  pname = "bs2b-lv2";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "nilninull";
    repo = "bs2b-lv2";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-dOcDPtiKN9Kfs2cdaeDO/GkWrh5tfJSHfiHPBtxJXvc=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    wafHook
  ];

  buildInputs = [
    libbs2b
    lv2
  ];

  meta = with lib; {
    description = "LV2 plugin for using Bauer stereophonic-to-binaural DSP library";
    homepage = "https://github.com/nilninull/bs2b-lv2";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
