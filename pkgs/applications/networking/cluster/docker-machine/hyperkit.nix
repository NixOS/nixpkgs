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
    postPatch
    ;

  pname = "docker-machine-hyperkit";

  buildPhase = ''
    make docker-machine-driver-hyperkit COMMIT=${src.rev}
  '';

  installPhase = ''
    install out/docker-machine-driver-hyperkit -Dt $out/bin
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://minikube.sigs.k8s.io/docs/drivers/hyperkit";
    description = "HyperKit driver for docker-machine";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ atkinschang ];
=======
  meta = with lib; {
    homepage = "https://minikube.sigs.k8s.io/docs/drivers/hyperkit";
    description = "HyperKit driver for docker-machine";
    license = licenses.asl20;
    maintainers = with maintainers; [ atkinschang ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [ "x86_64-darwin" ];
  };
}
