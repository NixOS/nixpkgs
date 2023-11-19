{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pe-bear";
  version = "0.6.5.2";

  src = fetchFromGitHub {
    owner = "hasherezade";
    repo = "pe-bear";
    rev = "v${version}";
    sha256 = "sha256-00OebZZUUwQ1yruTKEUj+bNEKY/CuzdLEbejnnagPnY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  meta = with lib; {
    description = "Portable Executable reversing tool with a friendly GUI";
    homepage = "https://hshrzd.wordpress.com/pe-bear/";

    license = [
      # PE-Bear
      licenses.gpl2Only

      # Vendored capstone
      licenses.bsd3

      # Vendored bearparser
      licenses.bsd2
    ];

    maintainers = with maintainers; [ blitz ];
    platforms = platforms.linux;
  };
}
