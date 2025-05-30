{
  stdenv,
  cmake,
  lib,
  fetchFromGitLab,
  qtmultimedia,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  ...
}:

stdenv.mkDerivation rec {
  pname = "tipp10";
  version = "3.3.3";

  src = fetchFromGitLab {
    owner = "tipp10";
    repo = "tipp10";
    rev = "v${version}";
    hash = "sha256-OiBtUizN6OjcAb5RLvzfod6tVQo/b8p8Ec4lgKYaifw=";
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
