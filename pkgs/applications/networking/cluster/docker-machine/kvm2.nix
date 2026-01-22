{
  lib,
  buildGoModule,
  minikube,
}:

buildGoModule rec {
  inherit (minikube)
    version
    src
    nativeBuildInputs
    buildInputs
    vendorHash
    doCheck
    ;

  pname = "docker-machine-kvm2";

  postPatch = minikube.postPatch + ''
    sed -i '/GOARCH=$*/d' Makefile
  '';

  buildPhase = ''
    make docker-machine-driver-kvm2 COMMIT=${src.rev}
  '';

  installPhase = ''
    install out/docker-machine-driver-kvm2 -Dt $out/bin
  '';

  meta = {
    homepage = "https://minikube.sigs.k8s.io/docs/drivers/kvm2";
    description = "KVM2 driver for docker-machine";
    mainProgram = "docker-machine-driver-kvm2";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tadfisher
      atkinschang
    ];
    platforms = lib.platforms.linux;
  };
}
