{ lib
, stdenv
, fetchFromGitHub
, mpir
, gmp
, mpfr
, flint
}:

stdenv.mkDerivation rec {
  pname = "antic";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "flintlib";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bQ2VvCS+lGro5qxs+qBz3RpUenxQTmTr+lm9BFZWYts=";
  };

  buildInputs = [ mpir gmp mpfr flint ];

  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpir=${mpir}"
    "--with-mpfr=${mpfr}"
    "--with-flint=${flint}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Algebraic number theory library";
    homepage = "https://github.com/flintlib/antic";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ smasher164 ];
    platforms = platforms.unix;
  };
}
