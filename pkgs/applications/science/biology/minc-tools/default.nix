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
  version = "unstable-2020-07-25";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = pname;
    rev = "fb0a68a07d281e4e099c5d54df29925240de14c1";
    sha256 = "0zcv2sdj3k6k0xjqdq8j5bxq8smm48dzai90vwsmz8znmbbm6kvw";
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
