{
  stdenv,
  cmake,
  lib,
  fetchFromGitLab,
  qtmultimedia,
  qttools,
  wrapQtAppsHook,
  ...
}:

stdenv.mkDerivation rec {
  pname = "tipp10";
  version = "3.3.2";

  src = fetchFromGitLab {
    owner = "tipp10";
    repo = "tipp10";
    rev = "v${version}";
    sha256 = "sha256-e0sWH4pT7ej9XGK/Sg9XMX2bMqcXqtSaYI7KBZTXvp4=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];
  buildInputs = [ qtmultimedia ];

  meta = with lib; {
    description = "Learn and train typing with the ten-finger system";
    mainProgram = "tipp10";
    homepage = "https://gitlab.com/tipp10/tipp10";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sigmanificient ];
    platforms = platforms.all;
  };
}
