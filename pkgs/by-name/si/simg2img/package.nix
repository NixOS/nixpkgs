{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "simg2img";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "anestisb";
    repo = "android-simg2img";
    rev = version;
    hash = "sha256-sNHdSbms35YnENASFEG+VMLJGkV/JAlQUVMquDrePDc=";
  };

  buildInputs = [ zlib ];

  makeFlags = [
    "PREFIX=$(out)"
    "DEP_CXX:=$(CXX)"
  ];

  meta = with lib; {
    description = "Tool to convert Android sparse images to raw images";
    homepage = "https://github.com/anestisb/android-simg2img";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      dezgeg
      arkivm
    ];
  };
}
