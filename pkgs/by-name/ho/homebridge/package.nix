{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "homebridge";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JHeyyPh2ePIrUhqfo1Cb4pNf+lB3ldE6NR0OunbLuKk=";
  };

  npmDepsHash = "sha256-zJ9WPnhtC0rnyT5dqPfC/eg+TRlKlDDQW3XYx67pl5s=";

  meta = {
    description = "Lightweight emulator of iOS HomeKit API";
    homepage = "https://github.com/homebridge/homebridge";
    license = lib.licenses.asl20;
    mainProgram = "homebridge";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
})
