{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  mkfontdir,
  mkfontscale,
}:

stdenvNoCC.mkDerivation {
  pname = "beon";
  version = "2024-02-26";

  src = fetchFromGitHub {
    owner = "noirblancrouge";
    repo = "Beon";
    rev = "c0379c80a3b7d01532413f43f49904b2567341ac";
    hash = "sha256-jBLVVykHFJamOVF6GSRnQqYixqOrw5K1oV1B3sl4Zoc=";
  };

  nativeBuildInputs = [
    mkfontscale
    mkfontdir
  ];

  installPhase = ''
    runHook preInstall

    install -D -v fonts/ttf/Beon-Regular.ttf $out/share/fonts/truetype/Beon-Regular.ttf
    cd $out/share/fonts
    mkfontdir
    mkfontscale

    runHook postInstall
  '';

  meta = {
    description = "Neon stencil typeface";
    homepage = "https://noirblancrouge.com/fonts/beon-display";
    changelog = "https://github.com/noirblancrouge/Beon#changelog";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ raboof ];
    platforms = lib.platforms.all;
  };
}
