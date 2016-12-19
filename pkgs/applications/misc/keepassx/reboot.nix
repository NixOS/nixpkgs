{ stdenv, fetchFromGitHub, cmake, libgcrypt, qt5, zlib, libmicrohttpd, libXtst }:

stdenv.mkDerivation rec {
  name = "keepassx-reboot-${version}";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassx";
    rev = "${version}-http";
    sha256 = "0pj3mirhw87hk9nlls9hgfx08xrr8ln7d1fqi3fcm519qjr72lmv";
  };

  buildInputs = [ cmake libgcrypt zlib qt5.full libXtst libmicrohttpd ];

  meta = {
    description = "Fork of the keepassX password-manager with additional http-interface to allow browser-integration an use with plugins such as PasslFox (https://github.com/pfn/passifox). See also keepassX2.";
    homepage = https://github.com/keepassxreboot/keepassx;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ s1lvester jonafato ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
