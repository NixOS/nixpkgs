{ lib, buildGoModule, minikube }:

buildGoModule rec {
  inherit (minikube) version src nativeBuildInputs buildInputs vendorSha256;

  pname = "docker-machine-kvm2";

  postPatch = ''
    sed -i '/GOARCH=$*/d' Makefile
  '';

  buildPhase = ''
    make docker-machine-driver-kvm2 COMMIT=${src.rev}
  '';

  installPhase = ''
    install out/docker-machine-driver-kvm2 -Dt $out/bin
  '';

  meta = with lib; {
    homepage = "https://minikube.sigs.k8s.io/docs/drivers/kvm2";
    description = "KVM2 driver for docker-machine.";
    license = licenses.asl20;
    maintainers = with maintainers; [ tadfisher atkinschang ];
    platforms = platforms.linux;
  };
}
