{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "material-icons";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = finalAttrs.version;
    hash = "sha256-wX7UejIYUxXOnrH2WZYku9ljv4ZAlvgk8EEJJHOCCjE=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ installFonts ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "System status icons by Google, featuring material design";
    homepage = "https://material.io/icons";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mpcsh ];
  };
})
