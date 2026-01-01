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

<<<<<<< HEAD
  meta = {
    homepage = "http://opensource.yubico.com/yubico-c/";
    description = "C library for manipulating Yubico YubiKey One-Time Passwords (OTPs)";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    homepage = "http://opensource.yubico.com/yubico-c/";
    description = "C library for manipulating Yubico YubiKey One-Time Passwords (OTPs)";
    license = licenses.bsd2;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
