{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  sqlite,
  qtbase,
  qtsvg,
  qttools,
  wrapQtAppsHook,
  icoutils, # build and runtime deps.
  wget,
  fuseiso,
  wine,
  which, # runtime deps.
}:

stdenv.mkDerivation rec {
  pname = "q4wine";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "brezerk";
    repo = "q4wine";
    rev = "v${version}";
    sha256 = "sha256-5rj+EDsOZib78gWT003a4IN23cZQftnhVggIdLN6f7I=";
  };

  buildInputs = [
    sqlite
    icoutils
    qtbase
    qtsvg
    qttools
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
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

  meta = with lib; {
    homepage = "https://q4wine.brezblock.org.ua/";
    description = "Qt GUI for Wine to manage prefixes and applications";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rkitover ];
    platforms = platforms.unix;
  };
}
