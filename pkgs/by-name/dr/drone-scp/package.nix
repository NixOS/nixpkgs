{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "drone-scp";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = "drone-scp";
    rev = "v${version}";
    hash = "sha256-cVgKWdhmCdjEHGazZ1FMAOJMVyU5pl8aIgwFMhxlhzg=";
  };

  vendorHash = "sha256-2FEHklEa6TIB3jhmxR2yosPbtqMJcxeIDDnT2X2Xm+U=";

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
