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
  version = "1.11.0";

  # for -ldflags
  commit = "57e2f55f47effe9ce396cea42a1e0eb4f611ebbd";

  vendorSha256 = "1l9dxn7yy21x4b3cg6l5a08wx2ng8qf531ilg8yf1rznwfwjajrv";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "0y761svwyrpc4ywdd4vr9hxkg6593wg4wwqzn8n86g0zcz6qg11d";
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
