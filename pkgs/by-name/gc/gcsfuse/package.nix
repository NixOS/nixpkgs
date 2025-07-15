{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "gcsfuse";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    hash = "sha256-9qm3GmNzjIUdOa3w0cp+UpgTI3VX44qNKHPjoaPL1wc=";
  };

  vendorHash = "sha256-7aJ9Nqz4kg1oFCh+VlYPTWFZxACH9uACdhzAwGbAjbc=";

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
