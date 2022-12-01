{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, perlPackages, libminc }:

stdenv.mkDerivation rec {
  pname = "mni_autoreg";
  version = "unstable-2022-05-20";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = pname;
    rev = "be7bd25bf7776974e0f2c1d90b6e7f8ccc0c8874";
    sha256 = "sGMZbCrdV6yAOgGiqvBFOUr6pGlTCqwy8yNrPxMoKco=";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ libminc ];
  propagatedBuildInputs = with perlPackages; [ perl GetoptTabular MNI-Perllib ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];
  # testing broken: './minc_wrapper: Permission denied' from Testing/ellipse0.mnc

  postFixup = ''
    for prog in autocrop mritoself mritotal xfmtool; do
      echo $out/bin/$prog
      wrapProgram $out/bin/$prog --prefix PERL5LIB : $PERL5LIB;
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/mni_autoreg";
    description = "Tools for automated registration using the MINC image format";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
