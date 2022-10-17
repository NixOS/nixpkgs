{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, pkg-config
, which
, libvirt
, vmnet
, makeWrapper
}:

buildGoModule rec {
  pname = "minikube";
  version = "1.27.1";

  vendorSha256 = "sha256-2sXWf+iK1v9gv2DXhmEs8xlIRF+6EM7Y6Otd6F89zGk=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "sha256-GmvxKWHo0meiR1r5IlgI8jQRiDvmQafxTS9acv92EPk=";
  };

  nativeBuildInputs = [ installShellFiles pkg-config which makeWrapper ];

  buildInputs = if stdenv.isDarwin then [ vmnet ] else if stdenv.isLinux then [ libvirt ] else null;

  buildPhase = ''
    make COMMIT=${src.rev}
  '';

  installPhase = ''
    install out/minikube -Dt $out/bin

    wrapProgram $out/bin/minikube --set MINIKUBE_WANTUPDATENOTIFICATION false
    export HOME=$PWD

    for shell in bash zsh fish; do
      $out/bin/minikube completion $shell > minikube.$shell
      installShellCompletion minikube.$shell
    done
  '';

  meta = with lib; {
    homepage = "https://minikube.sigs.k8s.io";
    description = "A tool that makes it easy to run Kubernetes locally";
    license = licenses.asl20;
    maintainers = with maintainers; [ ebzzry copumpkin vdemeester atkinschang Chili-Man ];
    platforms = platforms.unix;
  };
}
