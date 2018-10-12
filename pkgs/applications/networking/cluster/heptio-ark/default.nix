{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "heptio-ark-${version}";
  version = "0.9.6";

  goPackagePath = "github.com/heptio/ark";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "heptio";
    repo = "ark";
    sha256 = "0q353a6f3hvg1gr6rmg8pbqnkrbgjchdr7f6f9503l1qbyyf95fz";
  };

  postInstall = "rm $bin/bin/generate";

  meta = with stdenv.lib; {
    description = "A utility for managing disaster recovery, specifically for your Kubernetes cluster resources and persistent volumes";
    homepage = https://heptio.github.io/ark/;
    license = licenses.asl20;
    maintainers = [maintainers.mbode];
    platforms = platforms.unix;
  };
}
