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
  version = "1.2.00-unstable-2023-01-19";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "inormalize";
    rev = "4928e573165d76551c3d273ccf0c46f4fbab11fc";
    hash = "sha256-ZxTsPBsaL/5BWC7ew57um8LPb96hytI30JE8saBBNw8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 3.1)" "CMAKE_MINIMUM_REQUIRED(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    libminc
    ebtks
  ]
  ++ (with perlPackages; [
    perl
    GetoptTabular
    MNI-Perllib
  ]);

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DEBTKS_DIR=${ebtks}/lib/"
  ];

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB
    done
  '';

  meta = {
    homepage = "https://github.com/BIC-MNI/inormalize";
    description = "Program to normalize intensity of MINC files";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
  };
}
