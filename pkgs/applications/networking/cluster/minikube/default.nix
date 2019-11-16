{ stdenv, buildGoModule, fetchFromGitHub, go-bindata, libvirt, qemu
, gpgme, makeWrapper, vmnet
, docker-machine-kvm, docker-machine-kvm2
, extraDrivers ? []
}:

let
  drivers = stdenv.lib.filter (d: d != null) (extraDrivers
            ++ stdenv.lib.optionals stdenv.isLinux [ docker-machine-kvm docker-machine-kvm2 ]);

  binPath = drivers
            ++ stdenv.lib.optionals stdenv.isLinux ([ libvirt qemu ]);

in buildGoModule rec {
  pname   = "minikube";
  version = "1.2.0";

  kubernetesVersion = "1.15.0";

  goPackagePath = "k8s.io/minikube";

  src = fetchFromGitHub {
    owner  = "kubernetes";
    repo   = "minikube";
    rev    = "v${version}";
    sha256 = "0l9znrp49877cp1bkwx84c8lv282ga5a946rjbxi8gznkf3kwaw7";
  };

  modSha256 = "1cp63n0x2lgbqvvymx9byx48r42qw6w224x5x4iiarc2nryfdhn0";

  buildInputs = [ go-bindata makeWrapper gpgme ] ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin vmnet;
  subPackages = [ "cmd/minikube" ] ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin "cmd/drivers/hyperkit";

  preBuild = ''
    go-bindata -nomemcopy -o pkg/minikube/assets/assets.go -pkg assets deploy/addons/...

    VERSION_MAJOR=$(grep "^VERSION_MAJOR" Makefile | sed "s/^.*\s//")
    VERSION_MINOR=$(grep "^VERSION_MINOR" Makefile | sed "s/^.*\s//")
    ISO_VERSION=v$VERSION_MAJOR.$VERSION_MINOR.0
    ISO_BUCKET=$(grep "^ISO_BUCKET" Makefile | sed "s/^.*\s//")
    KUBERNETES_VERSION=${kubernetesVersion}

    export buildFlagsArray="-ldflags=\
      -X k8s.io/minikube/pkg/version.version=v${version} \
      -X k8s.io/minikube/pkg/version.isoVersion=$ISO_VERSION \
      -X k8s.io/minikube/pkg/version.isoPath=$ISO_BUCKET \
      -X k8s.io/minikube/vendor/k8s.io/client-go/pkg/version.gitVersion=$KUBERNETES_VERSION \
      -X k8s.io/minikube/vendor/k8s.io/kubernetes/pkg/version.gitVersion=$KUBERNETES_VERSION"
  '';

  postInstall = ''
    wrapProgram $out/bin/${pname} --prefix PATH : $out/bin:${stdenv.lib.makeBinPath binPath}
    mkdir -p $out/share/bash-completion/completions/
    MINIKUBE_WANTUPDATENOTIFICATION=false MINIKUBE_WANTKUBECTLDOWNLOADMSG=false HOME=$PWD $out/bin/minikube completion bash > $out/share/bash-completion/completions/minikube
    mkdir -p $out/share/zsh/site-functions/
    MINIKUBE_WANTUPDATENOTIFICATION=false MINIKUBE_WANTKUBECTLDOWNLOADMSG=false HOME=$PWD $out/bin/minikube completion zsh > $out/share/zsh/site-functions/_minikube
  ''+ stdenv.lib.optionalString stdenv.hostPlatform.isDarwin ''
    mv $out/bin/hyperkit $out/bin/docker-machine-driver-hyperkit
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/kubernetes/minikube;
    description = "A tool that makes it easy to run Kubernetes locally";
    license     = licenses.asl20;
    maintainers = with maintainers; [ ebzzry copumpkin vdemeester ];
    platforms   = with platforms; unix;
  };
}
