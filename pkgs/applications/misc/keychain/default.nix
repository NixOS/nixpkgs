{ stdenv, fetchurl, pkgconfig, lib }:

stdenv.mkDerivation rec {
  name = "keychain-2.7.1";

  src = fetchurl {
    url = http://www.funtoo.org/archive/keychain/keychain-2.7.1.tar.bz2;
    sha256 = "1107fe3f78f6429d4861d64c5666f068f159326d22ab80a8ed0948cb25375191";
  };

  meta = {
    description = "Keychain helps you to manage ssh and GPG keys in a convenient and secure manner.";
    homepage = "https://github.com/funtoo/keychain";
    licenses = [ "GPLv2" ];
    maintainers = [ lib.maintainers.edwtjo ];
    platforms = with stdenv.lib.platforms; linux;
  }
}
