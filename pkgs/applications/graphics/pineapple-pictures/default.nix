{ lib
, stdenv
, fetchFromGitHub
, qtsvg
, qttools
, exiv2
, wrapQtAppsHook
, cmake
}:

stdenv.mkDerivation rec {
  pname = "pineapple-pictures";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
    rev = version;
    sha256 = "sha256-s4mJNPzrcg5UT8JC3D5ipaM8IvNFAK7e3V0TjVGeRdM=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtsvg
    exiv2
  ];

  meta = with lib; {
    description = "Homebrew lightweight image viewer";
    homepage = "https://github.com/BLumia/pineapple-pictures";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
