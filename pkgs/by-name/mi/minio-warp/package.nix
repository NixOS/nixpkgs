{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "minio-warp";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "warp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DHVk6SfDp02Y15k/c7oRfU94mnMg4oCdCyF5Q6dUC5o=";
  };

  vendorHash = "sha256-RkvYlZCUZ9PzM29sq6ABdeis7EuZluDz68++cnX9oIw=";

  # See .goreleaser.yml
  ldflags = [
    "-s"
    "-w"
    "-X github.com/minio/warp/pkg.ReleaseTag=v${finalAttrs.version}"
    "-X github.com/minio/warp/pkg.CommitID=${finalAttrs.src.rev}"
    "-X github.com/minio/warp/pkg.Version=${finalAttrs.version}"
    "-X github.com/minio/warp/pkg.ShortCommitID=${finalAttrs.src.rev}"
    "-X github.com/minio/warp/pkg.ReleaseTime=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    mv $out/bin/warp $out/bin/minio-warp
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "S3 benchmarking tool";
    homepage = "https://github.com/minio/warp";
    changelog = "https://github.com/minio/warp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ christoph-heiss ];
    mainProgram = "minio-warp";
  };
})
