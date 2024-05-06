{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "nttcp";
  version = "1.47";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/non-free/n/nttcp/nttcp_${version}.orig.tar.gz";
    sha256 = "1bl17dsd53lbpjdqfmpgpd7dms6d2w3scpg7ki7qgfjhs8sarq50";
  };

  patches = [
    # Fix format string compiler error
    ./format-security.patch
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "New test TCP program";
    license = licenses.unfree;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.all;
  };
}
