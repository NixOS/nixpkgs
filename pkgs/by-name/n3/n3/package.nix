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
  version = "unstable-2018-08-09";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "N3";
    rev = "010fc2ac58ce1d67b8e6a863fac0809d3203cb9b";
    sha256 = "06hci7gzhy8p34ggvx7gah2k9yxpwhgmq1cgw8pcd1r82g4rg6kd";
  };

  postPatch = ''
    substituteInPlace src/VolumeHist/DHistogram.cc \
      --replace "register " ""
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
    MNI-Perllib
    GetoptTabular
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
    homepage = "https://github.com/BIC-MNI/N3";
    description = "MRI non-uniformity correction for MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
