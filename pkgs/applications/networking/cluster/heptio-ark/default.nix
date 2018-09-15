{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "heptio-ark-${version}";
  version = "0.9.4";

  goPackagePath = "github.com/heptio/ark";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "heptio";
    repo = "ark";
    sha256 = "01z0zkw7l6haxky9l45iqqnvs6104xx4195jm250nv9j1x8n59ai";
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
