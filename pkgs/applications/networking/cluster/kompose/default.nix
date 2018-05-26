{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kompose-${version}";
  version = "1.9.0";

  goPackagePath = "github.com/kubernetes/kompose";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "kubernetes";
    repo = "kompose";
    sha256 = "00yvih5gn67sw9v30a0rpaj1zag7k02i4biw1p37agxih0aphc86";
  };

  meta = with stdenv.lib; {
    description = "A tool to help users who are familiar with docker-compose move to Kubernetes";
    homepage = https://github.com/kubernetes/kompose;
    license = licenses.asl20;
    maintainers = with maintainers; [thpham];
    platforms = platforms.unix;
  };
}
