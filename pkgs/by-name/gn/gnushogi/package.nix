{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "gnushogi";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://gnu/gnushogi/${pname}-${version}.tar.gz";
    hash = "sha256-HsxIqGYwPGNlJVKzJdaF5+9emJMkQIApGmHZZQXVKyk=";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/gnushogi/1.4.2-7/debian/patches/01-make-dont-ignore";
      hash = "sha256-Aw0zfH+wkj+rQQzKIn6bSilP76YIO27FwJ8n1UzG6ow=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/gnushogi/1.4.2-7/debian/patches/globals";
      hash = "sha256-wZJBPMYSz4n1kOyLmR9QOp70650R9xXQUWD5hvaMRok=";
    })
  ];

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "GNU implementation of Shogi, also known as Japanese Chess";
    mainProgram = "gnushogi";
    homepage = "https://www.gnu.org/software/gnushogi/";
    license = licenses.gpl3;
    maintainers = [ maintainers.ciil ];
    platforms = platforms.unix;
  };
}
