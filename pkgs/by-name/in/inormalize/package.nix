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
<<<<<<< HEAD
  version = "1.2.00-unstable-2023-01-19";
=======
  version = "unstable-2014-10-21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "inormalize";
<<<<<<< HEAD
    rev = "4928e573165d76551c3d273ccf0c46f4fbab11fc";
    hash = "sha256-ZxTsPBsaL/5BWC7ew57um8LPb96hytI30JE8saBBNw8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 3.1)" "CMAKE_MINIMUM_REQUIRED(VERSION 3.10)"
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
<<<<<<< HEAD

  buildInputs = [
    libminc
    ebtks
  ]
  ++ (with perlPackages; [
    perl
    GetoptTabular
    MNI-Perllib
  ]);
=======
  buildInputs = [
    libminc
    ebtks
  ];
  propagatedBuildInputs = with perlPackages; [
    perl
    GetoptTabular
    MNI-Perllib
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DEBTKS_DIR=${ebtks}/lib/"
  ];

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB
    done
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/BIC-MNI/inormalize";
    description = "Program to normalize intensity of MINC files";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
=======
  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/inormalize";
    description = "Program to normalize intensity of MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
