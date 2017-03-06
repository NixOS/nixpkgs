{ stdenv, fetchFromGitHub,
  cmake, libgcrypt, zlib, libmicrohttpd, libXtst, qtbase, qttools, libgpgerror
, withKeePassHTTP ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "keepassx-community-${version}";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = "${version}";
    sha256 = "0ncc157xki1mzxfa41bgwjfsz5jq9sq750ka578lq61smyzh5lq6";
  };

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
