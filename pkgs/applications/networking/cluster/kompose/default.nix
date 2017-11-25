{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kompose-${version}";
  version = "1.5.0";

  goPackagePath = "github.com/kubernetes/kompose";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "kubernetes";
    repo = "kompose";
    sha256 = "1r5f8jbr2c1xxb5fpfgy23w4m30zahhmrw23jlk1hpx2w1pi1iyh";
  };

  meta = with stdenv.lib; {
    description = "A tool to help users who are familiar with docker-compose move to Kubernetes";
    homepage = https://github.com/kubernetes/kompose;
    license = licenses.asl20;
    maintainers = with maintainers; [thpham];
    platforms = platforms.unix;
  };
}
