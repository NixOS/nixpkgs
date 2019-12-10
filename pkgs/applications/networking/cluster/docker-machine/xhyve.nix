{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, cctools, Hypervisor, vmnet }:

buildGoPackage rec {
  pname = "docker-machine-xhyve";
  version = "0.4.0";

  goPackagePath = "github.com/zchee/docker-machine-driver-xhyve";

  preBuild = ''
    make -C go/src/${goPackagePath} CC=${stdenv.cc}/bin/cc LIBTOOL=${cctools}/bin/libtool GIT_CMD=: lib9p
    export CGO_CFLAGS=-I$(pwd)/go/src/${goPackagePath}/vendor/github.com/jceel/lib9p
    export CGO_LDFLAGS=$(pwd)/go/src/${goPackagePath}/vendor/build/lib9p/lib9p.a
  '';
  buildFlags = "--tags lib9p";

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
