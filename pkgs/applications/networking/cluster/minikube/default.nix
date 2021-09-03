{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, pkg-config
, which
, libvirt
, vmnet
}:

buildGoModule rec {
  pname = "minikube";
  version = "1.22.0";

  vendorSha256 = "sha256-zAXEwGJ3dnqN/+3k189zqppdiNHPyJ+mdZvDNEWQLsA=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "sha256-wL/HsdV6MZcsR3Y8pGZ5WYUMJ7j+VyJGpLeLIXm5MJM=";
  };

  nativeBuildInputs = [ installShellFiles pkg-config which ];

  buildInputs = if stdenv.isDarwin then [ vmnet ] else if stdenv.isLinux then [ libvirt ] else null;

  buildPhase = ''
    make COMMIT=${src.rev}
  '';

  installPhase = ''
    install out/minikube -Dt $out/bin

    export HOME=$PWD
    export MINIKUBE_WANTUPDATENOTIFICATION=false
    export MINIKUBE_WANTKUBECTLDOWNLOADMSG=false

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
