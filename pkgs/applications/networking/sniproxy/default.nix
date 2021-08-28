{ lib, stdenv, fetchFromGitHub, autoreconfHook, gettext, libev, pcre, pkg-config, udns }:

stdenv.mkDerivation rec {
  pname = "sniproxy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dlundquist";
    repo = "sniproxy";
    rev = version;
    sha256 = "0isgl2lyq8vz5kkxpgyh1sgjlb6sqqybakr64w2mfh29k5ls8xzm";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ gettext libev pcre udns ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Transparent TLS and HTTP layer 4 proxy with SNI support";
    license = licenses.bsd2;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
