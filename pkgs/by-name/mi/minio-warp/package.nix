{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "minio-warp";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "warp";
    rev = "v${version}";
    hash = "sha256-bXThbMwT3T59nFCMEz8TnMMDYq26rDwKTOBamVGRsyM=";
  };

  vendorHash = "sha256-fo4LLRqqylx4oZOkLOgFzT436+vjap9dW+IpQ0IFa8Y=";

  # See .goreleaser.yml
  ldflags = [
    "-s"
    "-w"
    "-X github.com/minio/warp/pkg.ReleaseTag=v${version}"
    "-X github.com/minio/warp/pkg.CommitID=${src.rev}"
    "-X github.com/minio/warp/pkg.Version=${version}"
    "-X github.com/minio/warp/pkg.ShortCommitID=${src.rev}"
    "-X github.com/minio/warp/pkg.ReleaseTime=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    mv $out/bin/warp $out/bin/minio-warp
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "S3 benchmarking tool";
    homepage = "https://github.com/minio/warp";
    changelog = "https://github.com/minio/warp/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    mainProgram = "minio-warp";
  };
}
