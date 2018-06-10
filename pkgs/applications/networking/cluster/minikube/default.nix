{ stdenv, buildGoPackage, fetchFromGitHub, fetchurl, go-bindata, libvirt, qemu, docker-machine-kvm,
  gpgme, makeWrapper, hostPlatform, vmnet, python }:

let binPath = stdenv.lib.optionals stdenv.isLinux [ libvirt qemu docker-machine-kvm ];

in buildGoPackage rec {
  pname   = "minikube";
  name    = "${pname}-${version}";
  version = "0.27.0";

  goPackagePath = "k8s.io/minikube";

  src = fetchFromGitHub {
    owner  = "kubernetes";
    repo   = "minikube";
    rev    = "v${version}";
    sha256 = "00gj8x5p0vxwy0y0g5nnddmq049h7zxvhb73lb4gii5mghr9mkws";
  };

  buildInputs = [ go-bindata makeWrapper gpgme ] ++ stdenv.lib.optional hostPlatform.isDarwin vmnet;
  subPackages = [ "cmd/minikube" ] ++ stdenv.lib.optional hostPlatform.isDarwin "cmd/drivers/hyperkit";

  preBuild = ''
    pushd go/src/${goPackagePath} >/dev/null

    go-bindata -nomemcopy -o pkg/minikube/assets/assets.go -pkg assets deploy/addons/...

    ISO_VERSION=$(grep "^ISO_VERSION" Makefile | sed "s/^.*\s//")
    ISO_BUCKET=$(grep "^ISO_BUCKET" Makefile | sed "s/^.*\s//")
    KUBERNETES_VERSION=$(${python}/bin/python hack/get_k8s_version.py --k8s-version-only 2>&1) || true

    export buildFlagsArray="-ldflags=\
      -X k8s.io/minikube/pkg/version.version=v${version} \
      -X k8s.io/minikube/pkg/version.isoVersion=$ISO_VERSION \
      -X k8s.io/minikube/pkg/version.isoPath=$ISO_BUCKET \
      -X k8s.io/minikube/vendor/k8s.io/client-go/pkg/version.gitVersion=$KUBERNETES_VERSION \
      -X k8s.io/minikube/vendor/k8s.io/kubernetes/pkg/version.gitVersion=$KUBERNETES_VERSION"

    popd >/dev/null
  '';

  postInstall = ''
    mkdir -p $bin/share/bash-completion/completions/
    MINIKUBE_WANTUPDATENOTIFICATION=false MINIKUBE_WANTKUBECTLDOWNLOADMSG=false HOME=$PWD $bin/bin/minikube completion bash > $bin/share/bash-completion/completions/minikube
    mkdir -p $bin/share/zsh/site-functions/
    MINIKUBE_WANTUPDATENOTIFICATION=false MINIKUBE_WANTKUBECTLDOWNLOADMSG=false HOME=$PWD $bin/bin/minikube completion zsh > $bin/share/zsh/site-functions/_minikube
  '';

  postFixup = ''
    wrapProgram $bin/bin/${pname} --prefix PATH : $bin/bin:${stdenv.lib.makeBinPath binPath}
  '' + stdenv.lib.optionalString hostPlatform.isDarwin ''
    mv $bin/bin/hyperkit $bin/bin/docker-machine-driver-hyperkit
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/kubernetes/minikube;
    description = "A tool that makes it easy to run Kubernetes locally";
    license     = licenses.asl20;
    maintainers = with maintainers; [ ebzzry copumpkin ];
    platforms   = with platforms; unix;
  };
}
