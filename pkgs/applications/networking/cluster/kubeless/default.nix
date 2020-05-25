{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "kubeless";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "kubeless";
    repo = "kubeless";
    rev = "v${version}";
    sha256 = "1f5w6kn9rsaxx9nf6kzyjkzm3s9ycy1c8h78hb61v4x915xd3040";
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
