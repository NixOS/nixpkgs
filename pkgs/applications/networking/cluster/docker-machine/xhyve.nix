{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, Hypervisor, vmnet }:

buildGoPackage rec {
  name = "docker-machine-xhyve-${version}";
  version = "0.3.3";

  goPackagePath = "github.com/zchee/docker-machine-driver-xhyve";
  goDeps = ./xhyve-deps.nix;

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "zchee";
    repo   = "docker-machine-driver-xhyve";
    sha256 = "0rj6pyqp4yv4j28bglqjs95rip5i77vv8mrkmqv1rxrsl3i8aqqy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ Hypervisor vmnet ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zchee/docker-machine-driver-xhyve;
    description = "Xhyve driver for docker-machine.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ periklis ];
    platforms = platforms.darwin;
  };
}
