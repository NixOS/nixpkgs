{
  lib,
  cni-plugins,
  buildGoModule,
  firecracker,
  containerd,
  runc,
  makeWrapper,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "flintlock";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "liquidmetal-dev";
    repo = "flintlock";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-7Hdbao/ZqN3jqPQW3ZWlzEY+NBEP4Hf1UuO+Y42OIuM=";
  };

  vendorHash = "sha256-siKv10uL8ODaMenK3H1TTiPvRr3dOOqhILysH0fZCtw=";

  subPackages = [
    "cmd/flintlock-metrics"
    "cmd/flintlockd"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/weaveworks/flintlock/internal/version.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    firecracker
  ];

  postInstall = ''
    for prog in flintlockd flintlock-metrics; do
      wrapProgram "$out/bin/$prog" --prefix PATH : ${
        lib.makeBinPath [
          cni-plugins
          firecracker
          containerd
          runc
        ]
      }
    done
  '';

  meta = {
    description = "Create and manage the lifecycle of MicroVMs backed by containerd";
    homepage = "https://github.com/weaveworks-liquidmetal/flintlock";
    license = lib.licenses.mpl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ techknowlogick ];
  };
})
