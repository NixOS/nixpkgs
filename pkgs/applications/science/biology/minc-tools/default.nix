{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  flex,
  bison,
  perl,
  TextFormat,
  libminc,
  libjpeg,
  nifticlib,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "minc-tools";
  version = "2.3.06-unstable-2023-08-12";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = pname;
    rev = "c86a767dbb63aaa05ee981306fa09f6133bde427";
    hash = "sha256-PLNcuDU0ht1PcjloDhrPzpOpE42gbhPP3rfHtP7WnM4=";
  };

  nativeBuildInputs = [
    cmake
    flex
    bison
    makeWrapper
  ];

  buildInputs = [
    libminc
    libjpeg
    nifticlib
    zlib
  ];

  propagatedBuildInputs = [
    perl
    TextFormat
  ];

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DZNZ_INCLUDE_DIR=${nifticlib}/include/nifti"
    "-DNIFTI_INCLUDE_DIR=${nifticlib}/include/nifti"
  ];

  postFixup = ''
    for prog in minccomplete minchistory mincpik; do
      wrapProgram $out/bin/$prog --prefix PERL5LIB : $PERL5LIB
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/minc-tools";
    description = "Command-line utilities for working with MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
