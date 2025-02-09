{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "drone-scp";
  version = "1.6.13";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = "drone-scp";
    rev = "v${version}";
    hash = "sha256-xto5QPrrPzGFy9GYUfK8lFUcXxi9gGHHs/84FdSjbYc=";
  };

  vendorHash = "sha256-rVS2ZKeJou/ZfLvNMd6jMRYMYuDXiqGyZSSDX9y3FQo=";

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
