{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  version = "2.14.2";
  pname = "helm";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "0hxfyfpmhgr5jilp2xm9d5vxiq5fcgqm2hh4g4izcgiz9bz7b6k0";
  };

  goPackagePath = "k8s.io/helm";
  subPackages = [ "cmd/helm" "cmd/tiller" "cmd/rudder" ];

  goDeps = ./deps.nix;

  # Thsese are the original flags from the helm makefile
  buildFlagsArray = ''
    -ldflags=-X k8s.io/helm/pkg/version.Version=v${version} -X k8s.io/helm/pkg/version.GitTreeState=clean -X k8s.io/helm/pkg/version.BuildMetadata=
    -w
    -s
  '';

  preBuild = ''
    # This is a hack(?) to flatten the dependency tree the same way glide or dep would
    # Otherwise you'll get errors like
    # have DeepCopyObject() "k8s.io/kubernetes/vendor/k8s.io/apimachinery/pkg/runtime".Object
    # want DeepCopyObject() "k8s.io/apimachinery/pkg/runtime".Object
    rm -rf $NIX_BUILD_TOP/go/src/k8s.io/kubernetes/vendor
    rm -rf $NIX_BUILD_TOP/go/src/k8s.io/apiextensions-apiserver/vendor
  '';

  postInstall = ''
    mkdir -p $bin/share/bash-completion/completions
    mkdir -p $bin/share/zsh/site-functions
    $bin/bin/helm completion bash > $bin/share/bash-completion/completions/helm
    $bin/bin/helm completion zsh > $bin/share/zsh/site-functions/_helm
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/helm;
    description = "A package manager for kubernetes";
    license = licenses.asl20;
    maintainers = [ maintainers.rlupton20 maintainers.edude03 ];
  };
}
