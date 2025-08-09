{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "gcsfuse";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    hash = "sha256-xTICtyx6YPBe3hfme29M9pX/fX/w+/0pZWUMCbA6ajs=";
  };

  vendorHash = "sha256-eTtKjGDJwRJzIb0qLp/HHLc8cYdd3HdWuivVUZOYEBU=";

  subPackages = [
    "."
    "tools/mount_gcsfuse"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.gcsfuseVersion=${version}"
  ];

  checkFlags =
    let
      skippedTests = [
        # Disable flaky tests
        "Test_Main"
        "TestFlags"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    ln -s $out/bin/mount_gcsfuse $out/bin/mount.gcsfuse
    ln -s $out/bin/mount_gcsfuse $out/bin/mount.fuse.gcsfuse
  '';

  meta = {
    description = "User-space file system for interacting with Google Cloud Storage";
    homepage = "https://cloud.google.com/storage/docs/gcs-fuse";
    changelog = "https://github.com/GoogleCloudPlatform/gcsfuse/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    # internal/cache/file/downloader/job.go:386:77: undefined: syscall.O_DIRECT
    broken = stdenv.hostPlatform.isDarwin;
  };
}
