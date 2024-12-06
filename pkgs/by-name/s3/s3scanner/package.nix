{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "s3scanner";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "sa7mon";
    repo = "s3scanner";
    rev = "v${version}";
    hash = "sha256-RS/+m/snJIm8OxCgvh/Bn1u9ghvRgS8tYvy1v1DV02I=";
  };

  ldflags = [ "-s -w" ];

  vendorHash = "sha256-Ik5B01QnbhFQISAY3Bdb1g85Din+Ifcg1vbGZcbb1OY=";

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
