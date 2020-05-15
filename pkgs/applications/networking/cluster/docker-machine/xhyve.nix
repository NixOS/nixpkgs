{ stdenv, buildGoModule, fetchFromGitHub, fetchpatch, pkgconfig, cctools, Hypervisor, vmnet }:

buildGoModule rec {
  pname = "docker-machine-xhyve";
  version = "0.4.0";


  # https://github.com/machine-drivers/docker-machine-driver-xhyve/pull/225
  patches = fetchpatch {
    url = "https://github.com/machine-drivers/docker-machine-driver-xhyve/commit/546256494bf2ccc33e4125bf45f504b0e3027d5a.patch";
    sha256 = "1i8wxqccqkxvqrbsyd0g9s0kdskd8xi2jv0c1bji9aj4rq0a8cgz";
  };

  preBuild = ''
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
    homepage = "https://github.com/machine-drivers/docker-machine-driver-xhyve";
    description = "Xhyve driver for docker-machine.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ periklis ];
    platforms = platforms.darwin;
  };
}