{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libx11,
  cairo,
  lv2,
  fluidsynth,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fluida-lv2";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "Fluida.lv2";
    tag = "v${finalAttrs.version}";
    # submodule: https://github.com/brummer10/libxputty.git
    fetchSubmodules = true;
    hash = "sha256-n6eQGOTAXBRmSAXLdf9/zDWd8mq1z2D0w/784FQtO1A=";
  };

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    pkg-config
  ];

  buildInputs = [
    cairo
    fluidsynth
    libx11
    lv2
  ];

  postInstall = ''
    # Output files were installed in ~/.lv2
    # copy to the output directory:
    mkdir -p $out/lib/lv2
    cp -r $HOME/.lv2/* $out/lib/lv2/
  '';

  meta = {
    changelog = "https://github.com/brummer10/Fluida.lv2/releases/tag/v${finalAttrs.version}";
    description = "Fluidsynth as LV2 plugin";
    homepage = "https://github.com/brummer10/Fluida.lv2";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ joostn ];
    platforms = [ "x86_64-linux" ];
  };
})
