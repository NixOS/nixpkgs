{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libyubikey";
  version = "1.13";

  src = fetchurl {
    url = "https://developers.yubico.com/yubico-c/Releases/${pname}-${version}.tar.gz";
    sha256 = "009l3k2zyn06dbrlja2d4p2vfnzjhlcqxi88v02mlrnb17mx1v84";
  };

  meta = with lib; {
    homepage = "http://opensource.yubico.com/yubico-c/";
    description = "C library for manipulating Yubico YubiKey One-Time Passwords (OTPs)";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
