{ stdenv, fetchFromGitHub, cmake, makeWrapper,
  perlPackages,
  libminc, EBTKS }:

stdenv.mkDerivation rec {
  pname = "N3";
  name  = "${pname}-2017-09-18";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "2fdd939f0f2b24a4039bc6a8ade4a190a1d8e75d";
    sha256 = "13z21c4r09hna3q1csvcn4i7ws5ixbdaja6ch421xv6nydjh2w5g";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ libminc EBTKS ];
  propagatedBuildInputs = with perlPackages; [ perl MNI-Perllib GetoptTabular ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/" "-DEBTKS_DIR=${EBTKS}/lib/" ];

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/BIC-MNI/${pname}";
    description = "MRI non-uniformity correction for MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
