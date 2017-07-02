{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kube-dns-${version}";
  version = "1.14.2";

  goPackagePath = "k8s.io/dns";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "dns";
    rev = "${version}";
    sha256 = "0ap67hdmd6fa95aw0al920rnrr1abdd2cxd4ziaq1xclr2fjn632";
  };

  meta = with stdenv.lib; {
    description = "DNS Server for Kubernetes Containers";
    license = licenses.asl20;
    homepage = http://kubernetes.io;
    maintainers = with maintainers; [ offline lnl7 ];
    platforms = platforms.unix;
  };
}
