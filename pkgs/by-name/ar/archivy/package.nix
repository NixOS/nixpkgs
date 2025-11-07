{
  lib,
  python3,
  fetchPypi,
}:

let
  py = python3.override {
    self = py;
    packageOverrides = self: super: {
      wtforms = super.wtforms.overridePythonAttrs (oldAttrs: rec {
        version = "2.3.1";

        src = fetchPypi {
          pname = "WTForms";
          inherit version;
          sha256 = "sha256-hhoTs65SHWcA2sOydxlwvTVKY7pwQ+zDqCtSiFlqGXI=";
        };

        doCheck = false;
      });
    };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "archivy";
  version = "1.7.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XFzWD4KAW5jt5BwXZvO0iZdJKpzC6dRkxNLv5N8XUfc=";
  };

  build-system = with py.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = true;

  dependencies = with py.pkgs; [
    appdirs
    attrs
    beautifulsoup4
    click-plugins
    elasticsearch
    flask-compress
    flask-login
    flask-wtf
    html2text
    python-dotenv
    python-frontmatter
    readability-lxml
    requests
    setuptools # uses pkg_resources during runtime
    tinydb
    validators
    wtforms
  ];

  # __init__.py attempts to mkdir in read-only file system
  doCheck = false;

  meta = with lib; {
    description = "Self-hosted knowledge repository";
    homepage = "https://archivy.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
