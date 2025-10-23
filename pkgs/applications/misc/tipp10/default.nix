{
  stdenv,
  cmake,
  lib,
  fetchFromGitLab,
  qtmultimedia,
  qttools,
  qtwayland,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "tipp10";
  version = "3.3.4";

  src = fetchFromGitLab {
    owner = "tipp10";
    repo = "tipp10";
    rev = "v${version}";
    hash = "sha256-q5D+8Z9dNpCXgRQtVC+0RBHK2szv7M+dwlmW4H7j2qg=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];
  buildInputs = [
    qtmultimedia
    qtwayland
  ];

  meta = {
    description = "Learn and train typing with the ten-finger system";
    mainProgram = "tipp10";
    homepage = "https://gitlab.com/tipp10/tipp10";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
}
