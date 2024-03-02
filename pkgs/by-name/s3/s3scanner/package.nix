{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "s3scanner";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "sa7mon";
    repo = "s3scanner";
    rev = "v${version}";
    hash = "sha256-f1r5ubH7iLKuuEhs4MPNY779FjyASW1xOXtMtXvF/CY=";
  };

  ldflags = [ "-s -w" ];

  vendorHash = "sha256-3Y1izt6xLg7aNJNqIEXROxR3IGAIIeptHlnoYEcuLew=";

  # Requires networking
  doCheck = false;

  meta = with lib; {
    description = "Scan for misconfigured S3 buckets across S3-compatible APIs";
    downloadPage = "https://github.com/sa7mon/S3Scanner/releases/tag/v${version}";
    homepage = "https://github.com/sa7mon/s3scanner";
    license = licenses.mit;
    maintainers = with maintainers; [ lavafroth ];
    mainProgram = "s3scanner";
  };
}
