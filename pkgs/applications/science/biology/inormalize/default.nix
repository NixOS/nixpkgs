{ stdenv, fetchFromGitHub, cmake, makeWrapper,
  perlPackages,
  libminc, EBTKS }:

stdenv.mkDerivation rec {
  pname = "inormalize";
  name  = "${pname}-2014-10-21";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "79cea9cdfe7b99abfd40afda89ab2253b596ad2f";
    sha256 = "1ahqv5q0ljvji99a5q8azjkdf6bgp6nr8lwivkqwqs3jm0k5clq7";
  };

  patches = [ ./lgmask-interp.patch ./nu_correct_norm-interp.patch ];

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ libminc EBTKS ];
  propagatedBuildInputs = with perlPackages; [ perl GetoptTabular MNI-Perllib ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/" "-DEBTKS_DIR=${EBTKS}/lib/" ];

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/BIC-MNI/${pname}";
    description = "Program to normalize intensity of MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
