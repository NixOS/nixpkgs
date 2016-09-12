{ stdenv, fetchFromGitHub, cmake, libgcrypt, qt5, zlib, libmicrohttpd, libXtst }:

stdenv.mkDerivation rec {
  name = "keepassx2-http-unstable-${version}";
  version = "2016-05-27";

  src = fetchFromGitHub {
    owner = "droidmonkey";
    repo = "keepassx_http";
    rev = "bb2e1ee8da3a3245c3ca58978a979dd6b5c2472a";
    sha256 = "1rlbjs0i1kbrkksliisnykhki8f15g09xm3fwqlgcfc2czwbv5sv";
  };

  buildInputs = [ cmake libgcrypt zlib qt5.full libXtst libmicrohttpd ];

  meta = {
    description = "Fork of the keepassX password-manager with additional http-interface to allow browser-integration an use with plugins such as PasslFox (https://github.com/pfn/passifox). See also keepassX2.";
    homepage = http://www.keepassx.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ s1lvester ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
