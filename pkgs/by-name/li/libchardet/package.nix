{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "libchardet";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "Joungkyun";
    repo = "libchardet";
    rev = version;
    sha256 = "sha256-JhEiWM3q8X+eEBHxv8k9yYOaTGoJOzI+/iFYC0gZJJs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Mozilla's Universal Charset Detector C/C++ API";
    mainProgram = "chardet-config";
    homepage = "ftp://ftp.oops.org/pub/oops/libchardet/index.html";
    license = lib.licenses.mpl11;
    maintainers = [ lib.maintainers.abbradar ];
    platforms = lib.platforms.unix;
  };
}
