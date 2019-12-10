{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, Hypervisor, vmnet }:

buildGoPackage rec {
  pname = "docker-machine-xhyve";
  version = "0.4.0";

  goPackagePath = "github.com/zchee/docker-machine-driver-xhyve";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "machine-drivers";
    repo   = "docker-machine-driver-xhyve";
    sha256 = "0000v97fr8xc5b39v44hsa87wrbk4bcwyaaivxv4hxlf4vlgg863";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ Hypervisor vmnet ];

  meta = with stdenv.lib; {
    homepage = https://github.com/machine-drivers/docker-machine-driver-xhyve;
    description = "Xhyve driver for docker-machine.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ periklis ];
    platforms = platforms.darwin;
  };
}
