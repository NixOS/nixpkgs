{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "heptio-ark-${version}";
  version = "0.7.1";

  goPackagePath = "github.com/heptio/ark";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "heptio";
    repo = "ark";
    sha256 = "0j3x9zxcffxhlw0fxq2cw9ph37bqw90cbmf9xshmnj8yl9rbxp7y";
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
