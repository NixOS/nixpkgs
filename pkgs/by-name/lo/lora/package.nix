{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lora";
  version = "3.021";

  src = fetchFromGitHub {
    owner = "cyrealtype";
    repo = "lora";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v9wE9caI9HTCfO01Yf+s6KajF7WpnL12nu+IuOV7T+w=";
  };

  dontConfigure = true;
  dontBuild = true;

  passthru.updateScript = nix-update-script { };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/truetype $src/fonts/ttf/*.ttf
    install -Dm444 -t $out/share/fonts/opentype $src/fonts/otf/*.otf
    install -Dm444 -t $out/share/fonts/variable $src/fonts/variable/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Lora Font: well-balanced contemporary serif with roots in calligraphy";
    homepage = "https://github.com/cyrealtype/lora";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ofalvai ];
  };
})
