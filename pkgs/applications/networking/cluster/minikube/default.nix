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
  version = "1.28.0";

  vendorSha256 = "sha256-CyIpzwSYHbv96UoQ/SZXOl6v3xn3pvT39ZO+RpVHU5I=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "sha256-Gn/RXZedID0sh5qTcBNg7GeLtI1JZYKXEWg2RZGXlDw=";
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
