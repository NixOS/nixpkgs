{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  sqlite,
  qt6,
  icoutils, # build and runtime deps.
  wget,
  fuseiso,
  wine,
  which, # runtime deps.
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "q4wine";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "brezerk";
    repo = "q4wine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5rj+EDsOZib78gWT003a4IN23cZQftnhVggIdLN6f7I=";
  };

  buildInputs = [
    sqlite
    icoutils
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  # Add runtime deps.
  postInstall = ''
    wrapProgram $out/bin/q4wine \
      --prefix PATH : ${
        lib.makeBinPath [
          icoutils
          wget
          fuseiso
          wine
          which
        ]
      }
  '';

  meta = {
    homepage = "https://q4wine.brezblock.org.ua/";
    description = "Qt GUI for Wine to manage prefixes and applications";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rkitover ];
    platforms = lib.platforms.unix;
  };
})
