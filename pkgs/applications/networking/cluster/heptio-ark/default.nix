{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "heptio-ark-${version}";
  version = "0.10.0";

  goPackagePath = "github.com/heptio/ark";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "heptio";
    repo = "ark";
    sha256 = "18h9hvp95va0hyl268gnzciwy1dqmc57bpifbj885870rdfp0ffv";
  };

  postInstall = "rm $bin/bin/issue-template-gen";

  meta = with stdenv.lib; {
    description = "A utility for managing disaster recovery, specifically for your Kubernetes cluster resources and persistent volumes";
    homepage = https://heptio.github.io/ark/;
    license = licenses.asl20;
    maintainers = [maintainers.mbode];
    platforms = platforms.unix;
  };
}
