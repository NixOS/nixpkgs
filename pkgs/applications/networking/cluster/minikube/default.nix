{ stdenv
, buildGoModule
, fetchFromGitHub
, pkgconfig
, makeWrapper
, go-bindata
, libvirt
, vmnet
}:

buildGoModule rec {
  pname   = "minikube";
  version = "1.9.2";
  # for -ldflags
  commit  = "1b78a7b8a99ad6a3c62b8d22f57120d614d17935";

  goPackagePath = "k8s.io/minikube";
  subPackages   = [ "cmd/minikube" ];
  modSha256     = "1pxs6myszgma3rzz0nhfjbnylv6m0xzlinvmlg0c4ijvkkzxg3v5";

  src = fetchFromGitHub {
    owner  = "kubernetes";
    repo   = "minikube";
    rev    = "v${version}";
    sha256 = "025v45427d885qkjjg7ig8fgrvjalnf1lajsj0cnbwbih2m69svg";
  };

  nativeBuildInputs = [ pkgconfig go-bindata makeWrapper ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ libvirt ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ vmnet ];

  preBuild = ''
    go-bindata -nomemcopy -o pkg/minikube/assets/assets.go -pkg assets deploy/addons/...
    go-bindata -nomemcopy -o pkg/minikube/translate/translations.go -pkg translate translations/...

    VERSION_MAJOR=$(grep "^VERSION_MAJOR" Makefile | sed "s/^.*\s//")
    VERSION_MINOR=$(grep "^VERSION_MINOR" Makefile | sed "s/^.*\s//")
    ISO_VERSION=v$VERSION_MAJOR.$VERSION_MINOR.0
    ISO_BUCKET=$(grep "^ISO_BUCKET" Makefile | sed "s/^.*\s//")

    export buildFlagsArray="-ldflags=\
      -X ${goPackagePath}/pkg/version.version=v${version} \
      -X ${goPackagePath}/pkg/version.isoVersion=$ISO_VERSION \
      -X ${goPackagePath}/pkg/version.isoPath=$ISO_BUCKET \
      -X ${goPackagePath}/pkg/version.gitCommitID=${commit} \
      -X ${goPackagePath}/pkg/drivers/kvm.version=v${version} \
      -X ${goPackagePath}/pkg/drivers/kvm.gitCommitID=${commit} \
      -X ${goPackagePath}/pkg/drivers/hyperkit.version=v${version} \
      -X ${goPackagePath}/pkg/drivers/hyperkit.gitCommitID=${commit}"
  '';

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions/
    MINIKUBE_WANTUPDATENOTIFICATION=false MINIKUBE_WANTKUBECTLDOWNLOADMSG=false HOME=$PWD $out/bin/minikube completion bash > $out/share/bash-completion/completions/minikube

    mkdir -p $out/share/zsh/site-functions/
    MINIKUBE_WANTUPDATENOTIFICATION=false MINIKUBE_WANTKUBECTLDOWNLOADMSG=false HOME=$PWD $out/bin/minikube completion zsh > $out/share/zsh/site-functions/_minikube
  '';

  meta = with stdenv.lib; {
    homepage    = "https://github.com/kubernetes/minikube";
    description = "A tool that makes it easy to run Kubernetes locally";
    license     = licenses.asl20;
    maintainers = with maintainers; [ ebzzry copumpkin vdemeester atkinschang ];
    platforms   = with platforms; unix;
  };
}
