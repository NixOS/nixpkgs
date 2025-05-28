{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "gcsfuse";
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
    hash = "sha256-5sQU1yVt4oOSpanteeH2eBHNphbPoGPhS8m2ZkPr1sE=";
  };

  vendorHash = "sha256-aXhgl7CQavI6iSQ6AVt9x536bQxlbRIqkUf99MudoYI=";

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

  meta = with lib; {
    description = "User-space file system for interacting with Google Cloud Storage";
    homepage = "https://cloud.google.com/storage/docs/gcs-fuse";
    changelog = "https://github.com/GoogleCloudPlatform/gcsfuse/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
    # internal/cache/file/downloader/job.go:386:77: undefined: syscall.O_DIRECT
    broken = stdenv.hostPlatform.isDarwin;
  };
}
