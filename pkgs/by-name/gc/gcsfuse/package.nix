{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "gcsfuse";
<<<<<<< HEAD
  version = "3.5.5";
=======
  version = "3.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "googlecloudplatform";
    repo = "gcsfuse";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Nfrbs46F7a+oELxnUWpi3v/KKSUGFhp4Xy7bLBur3z8=";
  };

  vendorHash = "sha256-v+71MA4x+WUj6ROuIbuhP1S+f8UbKFjkS8XpFFM3qyk=";
=======
    hash = "sha256-hC8/vgngJ4lLF02uV1MurZyRG7dpcEg9gcZr+HWzaNE=";
  };

  vendorHash = "sha256-BirzhmYwFSs2poA5tNOlK2bDO71mCkgSck7fE9la2wA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    maintainers = [ ];
    # internal/cache/file/downloader/job.go:386:77: undefined: syscall.O_DIRECT
    broken = stdenv.hostPlatform.isDarwin;
  };
}
