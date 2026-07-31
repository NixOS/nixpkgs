{
  lib,
  python3,
  fetchFromGitHub,
  gettext,
}:
let
  version = "3.3.0";

  dependencies = with python3.pkgs; [
    pystitch
    inkex
    wxpython
    networkx
    platformdirs
    shapely
    lxml
    numpy
    jinja2
    colormath2
    flask
    fonttools
    trimesh
    diskcache
    flask-cors
  ];
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
    fetchSubmodules = true; # required to get the embedded fonts
    hash = "sha256-vQL0Zgzfi3YHfh/WKbIg1ZaaboQQoFj+f5QBvdD9JYU=";
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
    ./0001-force-frozen-True.patch
    ./0002-plugin-invocation-use-python-script-as-entrypoint.patch
  ];

  doCheck = false;

  postPatch = ''
    # Add shebang with python dependencies
    substituteInPlace lib/inx/utils.py --replace-fail ' interpreter="python"' ""
    sed -i -e '1i#!${pyEnv.interpreter}' inkstitch.py
    chmod a+x inkstitch.py
  '';

  postInstall = ''
    export SITE_PACKAGES=$(find "${pyEnv}" -type d -name 'site-packages')
    wrapProgram $out/share/inkscape/extensions/inkstitch/inkstitch.py \
      --set PYTHON_INKEX_PATH "$SITE_PACKAGES"
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = {
    description = "Inkscape extension for machine embroidery design";
    homepage = "https://inkstitch.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      tropf
      pluiedev
    ];
  };
}
