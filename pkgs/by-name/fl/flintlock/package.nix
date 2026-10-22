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
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "liquidmetal-dev";
    repo = "flintlock";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tHq5yikhDsOYw6IOugmRPVs581+inwDrvLPuOOwig3k=";
  };

  vendorHash = "sha256-cITGlNpWoR78R6DcFsh1mieGeNLhd9L6Ap4XB0orNUk=";

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
