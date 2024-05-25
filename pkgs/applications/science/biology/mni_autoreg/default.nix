{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, perlPackages, libminc }:

stdenv.mkDerivation rec {
  pname = "mni_autoreg";
  version = "unstable-2023-05-26";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = pname;
    rev = "2959ac5d345084f8480fb195a58c99c702aa7ff3";
    hash = "sha256-T7pvG1B649sSpOeLl2KizDPX3VVut8nHZ2QwgjcrFrQ=";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ libminc ];
  propagatedBuildInputs = with perlPackages; [ perl GetoptTabular MNI-Perllib ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];
  # testing broken: './minc_wrapper: Permission denied' from Testing/ellipse0.mnc

  postFixup = ''
    for prog in autocrop mritoself mritotal xfmtool; do
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
