{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  qt6,
}:
stdenv.mkDerivation rec {
  pname = "enyo-launcher";
  version = "2.0.7";

  src = fetchFromGitLab {
    owner = "sdcofer70";
    repo = "enyo-launcher";
    rev = version;
    hash = "sha256-Ig1b+JylRlxhl5k5ys9SOGMYw3eUxXyoVXt3YNeWNqI=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];
  buildInputs = [ qt6.qtbase ];

  meta = {
    homepage = "https://gitlab.com/sdcofer70/enyo-launcher";
    description = "Frontend for Doom engines";
    mainProgram = "enyo-launcher";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.usrfriendly ];
  };
}
