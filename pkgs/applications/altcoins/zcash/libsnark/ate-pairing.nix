{ stdenv, xbyak, gmp, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ate-pairing-unstable-${version}";
  version = "2016-05-03";

  src = fetchFromGitHub {
    owner = "herumi";
    repo  = "ate-pairing";
    rev = "dcb9da999b1113f90b115bccb6f4b57ddf3a8452";
    sha256 = "0jr6r1cma414k8mhsyp7n8hqaqxi7zklsp6820a095sbb3zajckh";
  };

  buildInputs = [ gmp xbyak ];

  installPhase = ''
    mkdir -p $out
    cp -r lib $out
    cp -r include $out
  '';

  meta = with stdenv.lib; {
    description = "Optimal Ate Pairing over Barreto-Naehrig Curves";
    homepage = "https://github.com/herumi/ate-pairing";
    maintainers = with maintainers; [ rht ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
