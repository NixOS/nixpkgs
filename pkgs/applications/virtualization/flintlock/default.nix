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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flintlock";
    rev = "v${version}";
    sha256 = "sha256-kHrVpQ4E8b1YV+ofZwd4iGJ9ucVUUam6rxdpOGmvRR4=";
  };

  vendorSha256 = "sha256-A3LrikB2KrnSI+OREiLmlkTFpRKQWRB8w4OJ6ApX7oY=";

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
    homepage = "https://github.com/weaveworks-liquidmetal/flintlock";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ techknowlogick ];
  };
}
