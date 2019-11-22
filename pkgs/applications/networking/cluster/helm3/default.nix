{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  version = "3.0.0";
  pname = "helm3";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${version}";
    sha256 = "0gx5gmj1470q3gj8v043dmm31skf83p1ckzdcfzx8wdjlglsljrj";
  };

  modSha256 = "06599w4rvipb669vc5rj62k2kjakz2vmpp270carf204qbm5grk8";

  goPackagePath = "helm.sh/helm/v3";
  subPackages = [ "cmd/helm"];

  #goDeps = ./deps.nix;

  # Thsese are the original flags from the helm makefile
  buildFlagsArray = ''
    -ldflags=-X helm.sh/helm/v3/internal/version.Version=v${version} -X helm.sh/helm/v3/internal/version.GitTreeState=clean -X helm.sh/helm/v3/internal/version.BuildMetadata=
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

  meta = with stdenv.lib; {
    homepage = https://github.com/kubernetes/helm;
    description = "A package manager for kubernetes";
    license = licenses.asl20;
    maintainers = [ maintainers.rlupton20 maintainers.edude03 ];
  };
}
