{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lora";
  version = "3.006";

  src = fetchFromGitHub {
    owner = "cyrealtype";
    repo = "lora";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nNl2IC/KqYO6uS6ah0qWgesqm2cG8cIix/MhxbkOeAM=";
  };

  dontConfigure = true;
  dontBuild = true;

  passthru.updateScript = nix-update-script { };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp -R $src/fonts/ttf/*.ttf $out/share/fonts/truetype

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
