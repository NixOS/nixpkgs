{ lib, buildGoModule, minikube }:

buildGoModule rec {
  inherit (minikube) version src nativeBuildInputs buildInputs goPackagePath preBuild;

  pname = "docker-machine-kvm2";
  subPackages = [ "cmd/drivers/kvm" ];

  modSha256   = minikube.go-modules.outputHash;

  postInstall = ''
    mv $out/bin/kvm $out/bin/docker-machine-driver-kvm2
  '';

  meta = with lib; {
    homepage = https://github.com/kubernetes/minikube/blob/master/docs/drivers.md;
    description = "KVM2 driver for docker-machine.";
    license = licenses.asl20;
    maintainers = with maintainers; [ tadfisher atkinschang ];
    platforms = platforms.unix;
  };
}
