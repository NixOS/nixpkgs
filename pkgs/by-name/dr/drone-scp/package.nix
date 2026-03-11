{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "drone-scp";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = "drone-scp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qIIPvh+y1xPTXRGqUyCG2BnHQsgFlkbfi46vfM/Zgjg=";
  };

  vendorHash = "sha256-OCxqdb0VQP1jIRkiiAiyhRy15MiW2i9JbEATMedM0Bg=";

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
