{ stdenv
, lib
, fetchFromGitHub
, qmake
, pkg-config
, wrapQtAppsHook
, libarchive
, libpng
}:

stdenv.mkDerivation rec {
  pname = "CEmu";
  version = "unstable-2022-06-29";
  src = fetchFromGitHub {
    owner = "CE-Programming";
    repo = "CEmu";
    rev = "880d391ba9f8b7b2ec36ab9b45a34e9ecbf744e9";
    hash = "sha256-aFwGZJceh1jEP8cEajY5wYlSaFuNhYvSoZ/E1QDfJEI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    libarchive
    libpng
  ];

  qmakeFlags = [
    "gui/qt"
  ];

  meta = with lib; {
    description = "Third-party TI-84 Plus CE / TI-83 Premium CE emulator, focused on developer features";
    homepage = "https://ce-programming.github.io/CEmu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    broken = stdenv.isDarwin;
  };
}
