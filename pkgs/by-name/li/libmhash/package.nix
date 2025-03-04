{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "mhash";
  version = "0.9.9.9";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1w7yiljan8gf1ibiypi6hm3r363imm3sxl1j8hapjdq3m591qljn";
  };

  dontDisableStatic = true;

  patches = [ ./autotools-define-conflict-debian-fix.patch ];

  meta = {
    description = "Hash algorithms library";
    longDescription = ''
      Libmhash is a library that provides a uniform interface to several hash
      algorithms. It supports the basics for message authentication by
      following rfc2104 (HMAC). It also includes some key generation algorithms
      which are based on hash algorithms.
    '';
    homepage = "https://mhash.sourceforge.net";
    license = "LGPL";
    platforms = lib.platforms.unix;
  };
}
