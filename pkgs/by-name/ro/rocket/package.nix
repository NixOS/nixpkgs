{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:

stdenv.mkDerivation {
  pname = "rocket";
  version = "2018-06-09";

  src = fetchFromGitHub {
    owner = "rocket";
    repo = "rocket";
    rev = "7bc1e9826cad5dbc63e56371c6aa1798b2a7b50b";
    hash = "sha256-NzchnBVaCU2vGautgoAXUfGxaMNXp/H1CfN6w5p4bY0=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [ libsForQt5.qtbase ];

  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r editor/editor $out/bin/
  '';

  meta = {
    description = "Tool for synchronizing music and visuals in demoscene productions";
    mainProgram = "editor";
    homepage = "https://github.com/rocket/rocket";
    license = lib.licenses.zlib;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
