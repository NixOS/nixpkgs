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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
    rev = version;
    sha256 = "sha256-KTYwe6fS/rUHBbC2B9OdK95mFm3zvgDdGODkg7VQ27M=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtsvg
    exiv2.lib
  ];

  meta = with lib; {
    description = "Homebrew lightweight image viewer";
    homepage = "https://github.com/BLumia/pineapple-pictures";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
