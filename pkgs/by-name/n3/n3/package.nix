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
  pname = "N3";
  version = "1.12.00-unstable-2023-01-19";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "N3";
    rev = "96194790a577293163b6319d00539c8af45c195e";
    hash = "sha256-iA2dMOc+dlraT44zITrvOLIaJ3iH4a/fU5aS/YzIEGQ=";
  };

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
    MNI-Perllib
    GetoptTabular
  ]);

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DEBTKS_DIR=${ebtks}/lib/"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
  ];

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB
    done
  '';

  meta = {
    homepage = "https://github.com/BIC-MNI/N3";
    description = "MRI non-uniformity correction for MINC files";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
  };
}
