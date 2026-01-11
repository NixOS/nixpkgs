{
  lib,
  python3,
  fetchFromGitHub,
  gettext,
  gobject-introspection,
  wrapGAppsHook3,
  pango,
  gtksourceview3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "genxword";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "riverrun";
    repo = "genxword";
    tag = "v${version}";
    hash = "sha256-vzzkXfMnkeTFQmTNAfCIKqVVNm1I6GSfRV1lwGmLj6Y=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    pango
    gtksourceview3
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    pycairo
    pygobject3
  ];

  # to prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # there are no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/riverrun/genxword";
    description = "Crossword generator";
    license = lib.licenses.gpl3Plus;
    mainProgram = "genxword";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
