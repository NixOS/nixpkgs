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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flintlock";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Kbk94sqj0aPsVonPsiu8kbjhIOURB1kX9Lt3NURL+jk=";
  };

  vendorHash = "sha256-Iv1qHEQLgw6huCA/6PKNmm+dS2yHgOvY/oy2fKjwEpY=";

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
