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
<<<<<<< HEAD
  version = "1.12.00-unstable-2023-01-19";
=======
  version = "unstable-2018-08-09";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "N3";
<<<<<<< HEAD
    rev = "96194790a577293163b6319d00539c8af45c195e";
    hash = "sha256-iA2dMOc+dlraT44zITrvOLIaJ3iH4a/fU5aS/YzIEGQ=";
  };

=======
    rev = "010fc2ac58ce1d67b8e6a863fac0809d3203cb9b";
    sha256 = "06hci7gzhy8p34ggvx7gah2k9yxpwhgmq1cgw8pcd1r82g4rg6kd";
  };

  postPatch = ''
    substituteInPlace src/VolumeHist/DHistogram.cc \
      --replace "register " ""
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    MNI-Perllib
    GetoptTabular
  ]);
=======
  buildInputs = [
    libminc
    ebtks
  ];
  propagatedBuildInputs = with perlPackages; [
    perl
    MNI-Perllib
    GetoptTabular
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DEBTKS_DIR=${ebtks}/lib/"
<<<<<<< HEAD
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postFixup = ''
    for p in $out/bin/*; do
      wrapProgram $p --prefix PERL5LIB : $PERL5LIB
    done
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/BIC-MNI/N3";
    description = "MRI non-uniformity correction for MINC files";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
=======
  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/N3";
    description = "MRI non-uniformity correction for MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
