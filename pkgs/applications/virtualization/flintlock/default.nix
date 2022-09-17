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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "flintlock";
    rev = "v${version}";
    sha256 = "sha256-zVsI8443/4joOhhuqhrUGsIW6iFvetW9BhHqASL+XUk=";
  };

  vendorSha256 = "sha256-PPda8/9WSiWQYyJJQhWo94g8LqGEEwx2u2j2wfqpOv0=";

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
