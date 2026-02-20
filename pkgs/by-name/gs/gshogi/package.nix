{
  lib,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  python3,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gshogi";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "johncheetham";
    repo = "gshogi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EPOIYPSFAhilxuZeYfuZ4Cd29ReJs/E4KNF5/lyzbxs=";
  };

  doCheck = false; # no tests available

  buildInputs = [
    gtk3
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    pygobject3
    pycairo
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "http://johncheetham.com/projects/gshogi/";
    description = "Graphical implementation of the Shogi board game, also known as Japanese Chess";
    mainProgram = "gshogi";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ciil ];
  };
})
