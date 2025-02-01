{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "s3scanner";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "sa7mon";
    repo = "s3scanner";
    rev = "v${version}";
    hash = "sha256-yQymMtXQam/PMNZMBeKWtDtdrFikjvE/Nh5K61NUaYI=";
  };

  ldflags = [ "-s -w" ];

  vendorHash = "sha256-Y7eIvZIUtp+sOENiaG/eliZEl41qTHN2k3vJCXsjlIw=";

  # Requires networking
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/sa7mon/S3Scanner/releases/tag/${src.rev}";
    description = "Scan for misconfigured S3 buckets across S3-compatible APIs";
    downloadPage = "https://github.com/sa7mon/S3Scanner/releases/tag/v${version}";
    homepage = "https://github.com/sa7mon/s3scanner";
    license = licenses.mit;
    maintainers = with maintainers; [ lavafroth ];
    mainProgram = "s3scanner";
  };
}
