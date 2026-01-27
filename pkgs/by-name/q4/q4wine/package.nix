{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  sqlite,
  kdePackages,
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
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qttools
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
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
