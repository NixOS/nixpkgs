{ stdenv, buildGoPackage, fetchgit, git }:

buildGoPackage rec {
  version = "2.11.0";
  name = "helm-${version}";

  src = fetchgit {
    url = "https://www.github.com/helm/helm.git";
    rev = "v${version}";
    sha256 = "1jjyyidffls0yzi00p7icg19f10wdrmcgb52migdy4kv2chvmrah";
    leaveDotGit = "true";
  };

  goPackagePath = "k8s.io/helm";
  subPackages = [ "cmd/helm" "cmd/tiller" "cmd/rudder" ];

  goDeps = ./deps.nix;

  # Thsese are the original flags from the helm makefile
  buildFlagsArray = ''
    -ldflags=
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

    # Helm uses these to know which version of the tiller docker image to install
    # without it `helm init` fails
    GIT_COMMIT=$(${git}/bin/git rev-parse HEAD)
    GIT_SHA=$(${git}/bin/git rev-parse --short HEAD)
    GIT_TAG="v${version}"
    GIT_DIRTY="clean" # $(test -n "`${git}/bin/git status --porcelain`" && echo "dirty" || echo "clean")

    # Explicitly needs to be empty to unset the default value
    buildFlagsArray+=" -X k8s.io/helm/pkg/version.BuildMetadata="
    buildFlagsArray+=" -X k8s.io/helm/pkg/version.Version=$GIT_TAG"
    buildFlagsArray+=" -X k8s.io/helm/pkg/version.GitCommit=$GIT_COMMIT"
    buildFlagsArray+=" -X k8s.io/helm/pkg/version.GitTreeState=$GIT_DIRTY"
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
