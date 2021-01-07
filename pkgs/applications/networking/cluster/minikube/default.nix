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
  version = "1.16.0";

  vendorSha256 = "0nc2f9h77h24f0nvai5wvgmf1gh09dqfwrb6d5qghmq03a459san";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "minikube";
    rev = "v${version}";
    sha256 = "00dn8yy7mna0j8rdcnxbgnd5vkjdkqij8akgqhvbd32kxpqss890";
  };

  nativeBuildInputs = [ go-bindata installShellFiles pkg-config which ];

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

  meta = with stdenv.lib; {
    homepage = "https://minikube.sigs.k8s.io";
    description = "A tool that makes it easy to run Kubernetes locally";
    license = licenses.asl20;
    maintainers = with maintainers; [ ebzzry copumpkin vdemeester atkinschang Chili-Man ];
    platforms = platforms.unix;
  };
}
