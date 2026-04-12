{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lora";
  version = ".3021";

  src = fetchFromGitHub {
    owner = "cyrealtype";
    repo = "lora";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v9wE9caI9HTCfO01Yf+s6KajF7WpnL12nu+IuOV7T+w=";
  };

  dontConfigure = true;
  dontBuild = true;

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ installFonts ];

  # installFonts adds a hook to `postInstall` that installs fonts
  # into the correct directories
  installPhase = ''
    runHook preInstall
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
