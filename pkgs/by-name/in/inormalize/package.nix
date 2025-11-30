{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  perlPackages,
  libminc,
  ebtks,
}:

stdenv.mkDerivation {
  pname = "inormalize";
  version = "unstable-2014-10-21";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "inormalize";
    rev = "79cea9cdfe7b99abfd40afda89ab2253b596ad2f";
    sha256 = "1ahqv5q0ljvji99a5q8azjkdf6bgp6nr8lwivkqwqs3jm0k5clq7";
  };

  patches = [
    ./lgmask-interp.patch
    ./nu_correct_norm-interp.patch
  ];

  postPatch = ''
    substituteInPlace inormalize.cc \
      --replace "clamp" "::clamp"
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [
    libminc
    ebtks
  ];
  propagatedBuildInputs = with perlPackages; [
    perl
    GetoptTabular
    MNI-Perllib
  ];

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DEBTKS_DIR=${ebtks}/lib/"
  ];

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/inormalize";
    description = "Program to normalize intensity of MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
