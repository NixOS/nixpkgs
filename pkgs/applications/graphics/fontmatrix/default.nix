{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qttools
, qtwebkit
}:

mkDerivation rec {
  pname = "fontmatrix";
  version = "0.9.100";

  src = fetchFromGitHub {
    owner = "fontmatrix";
    repo = "fontmatrix";
    rev = "v${version}";
    sha256 = "sha256-DtajGhx79DiecglXHja9q/TKVq8Jl2faQdA5Ib/yT88=";
  };

  buildInputs = [ qttools qtwebkit ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Fontmatrix is a free/libre font explorer for Linux, Windows and Mac";
    homepage = "https://github.com/fontmatrix/fontmatrix";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
