{ lib
, cni-plugins
, buildGoModule
, firecracker
, containerd
, runc
, makeWrapper
, fetchFromGitHub
}:

buildGoModule rec{
  pname = "flintlock";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flintlock";
    rev = "v${version}";
    sha256 = "sha256-uzsLvmp30pxDu0VtzRD1H4onL4sT/RC3CBnzfahm0Fw=";
  };

  vendorSha256 = "sha256-vkSO+mIEPO8urEYqMjQLoHB4mtSxfJC74zHWpQbQL9g=";

  subPackages = [ "cmd/flintlock-metrics" "cmd/flintlockd" ];

  ldflags = [ "-s" "-w" "-X github.com/weaveworks/flintlock/internal/version.Version=v${version}" ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    firecracker
  ];

  postInstall = ''
    for prog in flintlockd flintlock-metrics; do
      wrapProgram "$out/bin/$prog" --prefix PATH : ${lib.makeBinPath [ cni-plugins firecracker containerd runc ]}
    done
  '';

  meta = with lib; {
    description = "Create and manage the lifecycle of MicroVMs backed by containerd";
    homepage = "https://github.com/weaveworks/flintlock";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ techknowlogick ];
  };
}
