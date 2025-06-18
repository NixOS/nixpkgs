{
  lib,
  python3,
  fetchFromGitHub,
  gettext,
}:
let
  version = "3.1.0";
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
  pyEnv = python3.withPackages (_: dependencies);
in
python3.pkgs.buildPythonApplication {
  pname = "inkstitch";
  inherit version;
  pyproject = false; # Uses a Makefile (yikes)

  src = fetchFromGitHub {
    owner = "inkstitch";
    repo = "inkstitch";
    tag = "v${version}";
    hash = "sha256-CGhJsDRhElgemNv2BXqZr6Vi5EyBArFak7Duz545ivY=";
  };

  nativeBuildInputs = [
    gettext
    pyEnv
  ];

  inherit dependencies;

  env = {
    # to overwrite version string
    GITHUB_REF = version;
    BUILD = "nixpkgs";
  };
  makeFlags = [ "manual" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/inkscape/extensions
    cp -a . $out/share/inkscape/extensions/inkstitch

    runHook postInstall
  '';

  patches = [
    ./0001-force-frozen-true.patch
    ./0002-plugin-invocation-use-python-script-as-entrypoint.patch
  ];

  postPatch = ''
    # Add shebang with python dependencies
    substituteInPlace lib/inx/utils.py --replace-fail ' interpreter="python"' ""
    sed -i -e '1i#!${pyEnv.interpreter}' inkstitch.py
    chmod a+x inkstitch.py
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = {
    description = "Inkscape extension for machine embroidery design";
    homepage = "https://inkstitch.org/";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [
      tropf
      pluiedev
    ];
  };
}
