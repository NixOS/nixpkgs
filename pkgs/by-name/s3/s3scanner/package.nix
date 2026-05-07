{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "s3scanner";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "sa7mon";
    repo = "s3scanner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RS/+m/snJIm8OxCgvh/Bn1u9ghvRgS8tYvy1v1DV02I=";
  };

  ldflags = [ "-s -w" ];

  vendorHash = "sha256-Ik5B01QnbhFQISAY3Bdb1g85Din+Ifcg1vbGZcbb1OY=";

  # Requires networking
  doCheck = false;

  meta = {
    changelog = "https://github.com/sa7mon/S3Scanner/releases/tag/${finalAttrs.src.rev}";
    description = "Scan for misconfigured S3 buckets across S3-compatible APIs";
    downloadPage = "https://github.com/sa7mon/S3Scanner/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/sa7mon/s3scanner";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lavafroth ];
    mainProgram = "s3scanner";
  };
})
