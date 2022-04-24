{ lib, mkDerivation, fetchFromGitHub, cmake, file, qtbase, qttools, solid }:

mkDerivation {
  pname = "dfilemanager";
  version = "unstable-2020-09-04";

  src = fetchFromGitHub {
    owner = "probonopd";
    repo = "dfilemanager";
    rev = "c592d643d76942dc2c2ccb6e4bfdf53f5e805e48";
    sha256 = "7hIgaWjjOck5i4QbeVeQK7yrjK4yDoAZ5qY9RhM5ABY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase qttools file solid ];

  cmakeFlags = [ "-DQT5BUILD=true" ];

  meta = {
    homepage = "http://dfilemanager.sourceforge.net/";
    description = "File manager written in Qt/C++";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
