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
  version = "1.23.2";

  vendorSha256 = "sha256-Q6DadAmx/8TM+MrdaKgAjn0sVrKqTYoWdsmnN77yfKA=";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "sha256-PIgzGikVIno2Gd+kSjF4kLHuUKgPrPHoIJxAGblI8RQ=";
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
