{ lib, buildGoModule, minikube }:

buildGoModule rec {
  inherit (minikube) version src nativeBuildInputs buildInputs goPackagePath preBuild;

  pname = "docker-machine-hyperkit";
  subPackages = [ "cmd/drivers/hyperkit" ];

  modSha256   = minikube.go-modules.outputHash;

  postInstall = ''
    mv $out/bin/hyperkit $out/bin/docker-machine-driver-hyperkit
  '';

  meta = with lib; {
    homepage = https://github.com/kubernetes/minikube/blob/master/docs/drivers.md;
    description = "HyperKit driver for docker-machine.";
    license = licenses.asl20;
    maintainers = with maintainers; [ atkinschang ];
    platforms = platforms.darwin;
  };
}
