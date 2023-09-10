{ lib, mkDerivation, fetchFromGitHub, cmake, file, qtbase, qttools, solid }:

mkDerivation {
  pname = "dfilemanager";
  version = "unstable-2021-02-20";

  src = fetchFromGitHub {
    owner = "probonopd";
    repo = "dfilemanager";
    rev = "61179500a92575e05cf9a71d401c388726bfd73d";
    sha256 = "sha256-BHd2dZDVxy82vR6PyXIS5M6zBGJ4bQfOhdBCdOww4kc=";
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
