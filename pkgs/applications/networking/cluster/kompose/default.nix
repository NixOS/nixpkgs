{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "kompose";
  version = "1.18.0";

  goPackagePath = "github.com/kubernetes/kompose";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "kubernetes";
    repo = "kompose";
    sha256 = "1hb4bs710n9fghphhfakwg42wjscf136dcr05zwwfg7iyqx2cipc";
  };

  meta = with stdenv.lib; {
    description = "A tool to help users who are familiar with docker-compose move to Kubernetes";
    homepage = https://github.com/kubernetes/kompose;
    license = licenses.asl20;
    maintainers = with maintainers; [ thpham vdemeester ];
    platforms = platforms.unix;
  };
}
