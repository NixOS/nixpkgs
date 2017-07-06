{ stdenv, fetchFromGitHub, autoreconfHook, gettext, libev, pcre, pkgconfig, udns }:

stdenv.mkDerivation rec {
  name = "sniproxy-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dlundquist";
    repo = "sniproxy";
    rev = version;
    sha256 = "0nspisqdl0si5zpiiwkh9hhdy6h7lxw8l09rasflyawlmm680z1i";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gettext libev pcre udns ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Transparent TLS and HTTP layer 4 proxy with SNI support";
    license = licenses.bsd2;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
