{ stdenv, fetchFromGitHub, cmake, libgcrypt, zlib, libmicrohttpd, libXtst, qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "keepassx-community-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "keepassxreboot";
    repo = "keepassxc";
    rev = "${version}";
    sha256 = "0qwmi9f8ik3vkwl1kx7g3079h5ia4wl87y42nr5dal3ic1jc941p";
  };

  buildInputs = [ cmake libgcrypt zlib qtbase qttools libXtst libmicrohttpd ];

  meta = {
    description = "Fork of the keepassX password-manager with additional http-interface to allow browser-integration an use with plugins such as PasslFox (https://github.com/pfn/passifox). See also keepassX2.";
    homepage = https://github.com/keepassxreboot/keepassxc;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ s1lvester jonafato ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
