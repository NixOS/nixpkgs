{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "drone-scp";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = "drone-scp";
    rev = "v${version}";
    hash = "sha256-qIIPvh+y1xPTXRGqUyCG2BnHQsgFlkbfi46vfM/Zgjg=";
  };

  vendorHash = "sha256-OCxqdb0VQP1jIRkiiAiyhRy15MiW2i9JbEATMedM0Bg=";

  # Needs a specific user...
  doCheck = false;

  meta = with lib; {
    description = "Copy files and artifacts via SSH using a binary, docker or Drone CI";
    homepage = "https://github.com/appleboy/drone-scp";
    license = licenses.mit;
    maintainers = with maintainers; [ ambroisie ];
    mainProgram = "drone-scp";
  };
}
