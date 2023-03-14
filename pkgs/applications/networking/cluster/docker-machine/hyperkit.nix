{ lib, buildGoModule, minikube }:

buildGoModule rec {
  inherit (minikube) version src nativeBuildInputs buildInputs vendorHash doCheck;

  pname = "docker-machine-hyperkit";

  buildPhase = ''
    make docker-machine-driver-hyperkit COMMIT=${src.rev}
  '';

  installPhase = ''
    install out/docker-machine-driver-hyperkit -Dt $out/bin
  '';

  meta = with lib; {
    homepage = "https://minikube.sigs.k8s.io/docs/drivers/hyperkit";
    description = "HyperKit driver for docker-machine";
    license = licenses.asl20;
    maintainers = with maintainers; [ atkinschang ];
    platforms = platforms.darwin;
  };
}
