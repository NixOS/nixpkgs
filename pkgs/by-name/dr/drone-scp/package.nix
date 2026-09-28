{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "drone-scp";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = "drone-scp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Wh2DCy0JIPjKahJpAXKGdhvNEtk24BNRTdza9etA888=";
  };

  vendorHash = "sha256-GJwNG2vN/Vw0d3ecR8dMUdMp4P9Sh/WZ9C78AmJWezU=";

  # Needs a specific user...
  doCheck = false;

  meta = {
    description = "Copy files and artifacts via SSH using a binary, docker or Drone CI";
    homepage = "https://github.com/appleboy/drone-scp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "drone-scp";
  };
})
