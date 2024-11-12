{ lib, stdenv, fetchurl, pkg-config, libmnl }:

stdenv.mkDerivation rec {
  version = "1.0.3";
  pname = "libnetfilter_acct";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/libnetfilter_acct/files/${pname}-${version}.tar.bz2";
    sha256 = "06lsjndgfjsgfjr43px2n2wk3nr7whz6r405mks3887y7vpwwl22";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  meta = with lib; {
    homepage = "https://www.netfilter.org/projects/libnetfilter_acct/";
    description = "Userspace library providing interface to extended accounting infrastructure";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
