{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "kubeless";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "kubeless";
    repo = "kubeless";
    rev = "v${version}";
    sha256 = "1fcdyd1jf0yibfx9jc16m0vmazm2jymps92llh3vh5zqd36bxbyd";
  };

  goPackagePath = "github.com/kubeless/kubeless";

  subPackages = [ "cmd/kubeless" ];

  buildFlagsArray = ''
    -ldflags=-X github.com/kubeless/kubeless/pkg/version.Version=${version}
  '';

  meta = with stdenv.lib; {
    homepage = "https://kubeless.io";
    description = "The Kubernetes Native Serverless Framework";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    platforms = platforms.unix;
  };
}
