{ stdenv
, buildGoModule
, fetchFromGitHub
, go-bindata
, installShellFiles
, pkg-config
, which
, libvirt
, vmnet
}:

buildGoModule rec {
  pname = "minikube";
  version = "1.9.2";

  # for -ldflags
  commit = "1b78a7b8a99ad6a3c62b8d22f57120d614d17935";

  modSha256 = "1pxs6myszgma3rzz0nhfjbnylv6m0xzlinvmlg0c4ijvkkzxg3v5";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "025v45427d885qkjjg7ig8fgrvjalnf1lajsj0cnbwbih2m69svg";
  };

  nativeBuildInputs = [ go-bindata installShellFiles pkg-config which ];

  buildInputs = if stdenv.isDarwin then [ vmnet ] else if stdenv.isLinux then [ libvirt ] else null;

  buildPhase = ''
    make COMMIT=${commit}
  '';

  installPhase = ''
    install out/minikube -Dt $out/bin

    export HOME=$PWD
    export MINIKUBE_WANTUPDATENOTIFICATION=false
    export MINIKUBE_WANTKUBECTLDOWNLOADMSG=false

    for shell in bash zsh; do
      $out/bin/minikube completion $shell > minikube.$shell
      installShellCompletion minikube.$shell
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://minikube.sigs.k8s.io";
    description = "A tool that makes it easy to run Kubernetes locally";
    license = licenses.asl20;
    maintainers = with maintainers; [ ebzzry copumpkin vdemeester atkinschang ];
    platforms = platforms.unix;
  };
}
