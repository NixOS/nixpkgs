{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, gettext, libev, pcre, pkg-config, udns }:

stdenv.mkDerivation rec {
  pname = "sniproxy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dlundquist";
    repo = "sniproxy";
    rev = version;
    sha256 = "0isgl2lyq8vz5kkxpgyh1sgjlb6sqqybakr64w2mfh29k5ls8xzm";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchain support:
    #   https://github.com/dlundquist/sniproxy/pull/349
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/dlundquist/sniproxy/commit/711dd14affd5d0d918cd5fd245328450e60c7111.patch";
      sha256 = "1vlszib2gzxnkl9zbbrf2jz632j1nhs4aanpw7qqnx826zmli0a6";
    })
  ];

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
