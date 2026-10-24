{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "stargz-snapshotter";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "stargz-snapshotter";
    tag = "v${version}";
    hash = "sha256-5KxmUKb06ZSrYkfc3CV4XZLtwiznvRBAZ40L15icbYo=";
  };

  sourceRoot = "${src.name}/cmd";

  vendorHash = "sha256-zcUi9hIwzOuytwgVQRhlJrn8q6rjdzWv4siHxWSIh1o=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/containerd/stargz-snapshotter/version.Version=${version}"
    "-X github.com/containerd/stargz-snapshotter/version.Revision=${src.rev}"
  ];

  subPackages = [
    "containerd-stargz-grpc"
    "ctr-remote"
    "stargz-fuse-manager"
    "stargz-store"
    "stargz-store/helper"
  ];

  postInstall = ''
    mv $out/bin/helper $out/bin/stargz-store-helper
  '';

  meta = {
    description = "Fast container image distribution plugin with lazy pulling.";
    longDescription = ''
      Stargz Snapshotter is a containerd snapshotter plugin which enables
      lazy pulling of container images. It allows containers to launch
      faster because the snapshotter can start containers before completing
      the image pull.
    '';
    homepage = "https://github.com/containerd/stargz-snapshotter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ malt3 ];
    platforms = lib.platforms.linux;
    mainProgram = "containerd-stargz-grpc";
  };
}
