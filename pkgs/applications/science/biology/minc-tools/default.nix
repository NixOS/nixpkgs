{ stdenv, fetchFromGitHub, cmake, makeWrapper, flex, bison, perlPackages, libminc, libjpeg, zlib }:

stdenv.mkDerivation rec {
  pname = "minc-tools";
  name  = "${pname}-2017-09-11";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "5b7c40425cd4f67a018055cb85c0157ee50a3056";
    sha256 = "0zkcs05svp1gj5h0cdgc0k20c7lrk8m7wg3ks3xc5mkaiannj8g7";
  };

  nativeBuildInputs = [ cmake flex bison makeWrapper ];
  buildInputs = [ libminc libjpeg zlib ];
  propagatedBuildInputs = with perlPackages; [ perl TextFormat ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/" ];

  postFixup = ''
    for prog in minccomplete minchistory mincpik; do
      wrapProgram $out/bin/$prog --prefix PERL5LIB : $PERL5LIB
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/BIC-MNI/minc-tools;
    description = "Command-line utilities for working with MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
