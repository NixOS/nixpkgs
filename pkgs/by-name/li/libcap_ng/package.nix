{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libcap-ng";
  version = "0.8.5";

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/libcap-ng/libcap-ng-${version}.tar.gz";
    hash = "sha256-O6UpTRy9+pivqs+8ALavntK4PoohgXGF39hEzIx6xv8=";
  };

  outputs = [ "out" "dev" "man" ];

  configureFlags = [
    "--without-python"
  ];

  meta = with lib; {
    description = "Library for working with POSIX capabilities";
    homepage = "https://people.redhat.com/sgrubb/libcap-ng/";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
