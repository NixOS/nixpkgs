{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "homebridge";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bs7h9qHAWPNEqomTbit2LBtM5yLHQnFLjCMJ/ybHxHU=";
  };

  npmDepsHash = "sha256-/1mIwWFa6L7bLao0/Q3I+nniVt5crVa8ufuvkYeoJUY=";

  meta = {
    description = "Lightweight emulator of iOS HomeKit API";
    homepage = "https://github.com/homebridge/homebridge";
    license = lib.licenses.asl20;
    mainProgram = "homebridge";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
})
