{ stdenv, lib, fetchFromGitHub, autoreconfHook, go-md2man, pkgconfig
, libcap, libseccomp, python3, systemd, yajl }:

stdenv.mkDerivation rec {
  pname = "crun";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = version;
    sha256 = "0v1hrlpnln0c976fb0k2ig4jv11qbyzf95z0wy92fd8r8in16rc1";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook go-md2man pkgconfig python3 ];

  buildInputs = [ libcap libseccomp systemd yajl ];

  enableParallelBuilding = true;

  # the tests require additional permissions
  doCheck = false;

  meta = with lib; {
    description = "A fast and lightweight fully featured OCI runtime and C library for running containers";
    license = licenses.gpl3;
    platforms = platforms.linux;
    inherit (src.meta) homepage;
  };
}
