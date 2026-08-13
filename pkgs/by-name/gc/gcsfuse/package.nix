{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "gcsfuse";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XBEcr0YtLAuIG452jI0/xlTNjiku1PLaqWr+T7JGHYY=";
  };

  vendorHash = "sha256-egpUu2fF8XespVtP8zV+qDmDALv6CxiPmMCVghearm8=";

  subPackages = [
    "."
    "tools/mount_gcsfuse"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.gcsfuseVersion=${finalAttrs.version}"
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
    changelog = "https://github.com/GoogleCloudPlatform/gcsfuse/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    # internal/cache/file/downloader/job.go:386:77: undefined: syscall.O_DIRECT
    broken = stdenv.hostPlatform.isDarwin;
  };
})
