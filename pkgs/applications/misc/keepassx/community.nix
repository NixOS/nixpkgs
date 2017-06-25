{ stdenv, fetchFromGitHub, fetchpatch,
  cmake, libgcrypt, zlib, libmicrohttpd, libXtst, qtbase, qttools, libgpgerror
, withKeePassHTTP ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "keepassx-community-${version}";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = "${version}";
    sha256 = "1znnw2xpv58x0rbpmm4y662377mbmcilhf8mhhjsz8vhahms33a8";
  };

  patches = [
    (fetchpatch { # qt 4.9
      url = "https://github.com/keepassxreboot/keepassxc/commit/2b6059dee3a95591d787e8b8c931cd68c059d43f.patch";
      sha256 = "1v140z358rk75f7wsqawpai3x8v8qcqalnv9r0l1d4p1gxm1j766";
    })
  ];

  cmakeFlags = optional (withKeePassHTTP) [ "-DWITH_XC_HTTP=ON" ];

  buildInputs = [ cmake libgcrypt zlib qtbase qttools libXtst libmicrohttpd libgpgerror ];

  meta = {
    description = "Fork of the keepassX password-manager with additional http-interface to allow browser-integration an use with plugins such as PasslFox (https://github.com/pfn/passifox). See also keepassX2.";
    homepage = https://github.com/keepassxreboot/keepassxc;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ s1lvester jonafato ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
