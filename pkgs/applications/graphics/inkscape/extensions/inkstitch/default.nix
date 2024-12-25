{
  lib,
  python3,
  fetchFromGitHub,
  gettext,
}:
let
  version = "3.1.0";
in
python3.pkgs.buildPythonApplication {
  pname = "inkstitch";
  inherit version;
  pyproject = false; # Uses a Makefile (yikes)

  src = fetchFromGitHub {
    owner = "inkstitch";
    repo = "inkstitch";
    rev = "refs/tags/v${version}";
    hash = "sha256-CGhJsDRhElgemNv2BXqZr6Vi5EyBArFak7Duz545ivY=";
  };

  nativeBuildInputs = [
    gettext
  ];

  dependencies =
    with python3.pkgs;
    [
      pyembroidery
      inkex
      wxpython
      networkx
      shapely
      lxml
      appdirs
      numpy
      jinja2
      requests
      # Upstream wants colormath2 yet still refers to it as colormath. Curious.
      colormath
      flask
      fonttools
      trimesh
      scipy
      diskcache
      flask-cors
    ]
    # Inkstitch uses the builtin tomllib instead when Python >=3.11
    ++ lib.optional (pythonOlder "3.11") tomli;

  makeFlags = [ "manual" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/inkscape/extensions
    cp -a inx $out/share/inkscape/extensions/inkstitch

    runHook postInstall
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = {
    description = "Inkscape extension for machine embroidery design";
    homepage = "https://inkstitch.org/";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
