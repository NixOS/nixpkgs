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
with py.pkgs;

buildPythonApplication rec {
  pname = "archivy";
  version = "1.7.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ns1Y0DqqnTAQMEt+oBJ/P2gqKqPsX9P3/Z4561qzuns";
  };

  pythonRelaxDeps = true;

  propagatedBuildInputs = [
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
    setuptools
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
