{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
  fetchpatch,
}:

buildGoModule rec {
  pname = "minio-warp";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "warp";
    rev = "v${version}";
    hash = "sha256-KOhBSxR9P3Q6DpC8QCRaiw6Y51OyHLRlhr0WmXE74PI=";
  };

  patches = [
    # upstream ships a broken go.sum file in the release and fixes it one commit later ..
    (fetchpatch {
      url = "https://github.com/minio/warp/commit/c830e94367efce6e6d70c337d490a3b6eba5e558.patch";
      hash = "sha256-LXkgwpTPe4WvU+nAsYfjs38uXiBoeoavnxliw8nweRQ=";
    })
  ];

  vendorHash = "sha256-duEd5uss6mS2aTOTsI3dzZV2TEDHyKN5QKWb4Tt5+7s=";

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
