{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "drone-scp";
  version = "1.6.12";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = "drone-scp";
    rev = "v${version}";
    hash = "sha256-pdVSb+hOW38LMP6fwAxVy/8SyfwKcMe4SgemPZ1PlSg=";
  };

  vendorHash = "sha256-HQeWj5MmVfR6PkL2FEnaptMH+4nSh7T2wfOaZyUZvbM=";

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
