{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "drone-scp";
  version = "1.6.11";

  src = fetchFromGitHub {
    owner = "appleboy";
    repo = "drone-scp";
    rev = "v${version}";
    hash = "sha256-JCqiYPhuPKDcbg8eo4DFuUVazu+0e0YTnG87NZRARMU=";
  };

  vendorHash = "sha256-zPpwvU/shSK1bfm0Qc2VjifSzDTpFnsUiogQfQcdY7I=";

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
