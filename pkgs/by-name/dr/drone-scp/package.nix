{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "drone-scp";
  version = "1.6.14";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = "drone-scp";
    rev = "v${version}";
    hash = "sha256-RxpDlQ6lYT6XH5zrYZaRO5YsB++7Ujr7dvgsTtXIBfc=";
  };

  vendorHash = "sha256-0/RGPvafOLT/O0l9ENoiHLmtOaP3DpjmXjmotuxF944=";

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
