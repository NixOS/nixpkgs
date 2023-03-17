{ lib, stdenv, buildGoPackage, fetchFromGitHub, fetchpatch, pkg-config, cctools, Hypervisor, vmnet }:

buildGoPackage rec {
  pname = "docker-machine-xhyve";
  version = "0.4.0";

  goPackagePath = "github.com/zchee/docker-machine-driver-xhyve";

  # https://github.com/machine-drivers/docker-machine-driver-xhyve/pull/225
  patches = fetchpatch {
    url = "https://github.com/machine-drivers/docker-machine-driver-xhyve/commit/546256494bf2ccc33e4125bf45f504b0e3027d5a.patch";
    sha256 = "1i8wxqccqkxvqrbsyd0g9s0kdskd8xi2jv0c1bji9aj4rq0a8cgz";
  };

  preBuild = ''
    make -C go/src/${goPackagePath} CC=${stdenv.cc}/bin/cc LIBTOOL=${cctools}/bin/libtool GIT_CMD=: lib9p
    export CGO_CFLAGS=-I$(pwd)/go/src/${goPackagePath}/vendor/github.com/jceel/lib9p
    export CGO_LDFLAGS=$(pwd)/go/src/${goPackagePath}/vendor/build/lib9p/lib9p.a
  '';
  tags = [ "lib9p" ];

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "machine-drivers";
    repo   = "docker-machine-driver-xhyve";
    sha256 = "0000v97fr8xc5b39v44hsa87wrbk4bcwyaaivxv4hxlf4vlgg863";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ Hypervisor vmnet ];

  meta = with lib; {
    homepage = "https://github.com/machine-drivers/docker-machine-driver-xhyve";
    description = "Xhyve driver for docker-machine";
    license = licenses.bsd3;
    maintainers = with maintainers; [ periklis ];
    platforms = platforms.darwin;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
