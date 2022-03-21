{ lib, stdenv, python3, fetchPypi }:

let
  defaultOverrides = [
    (self: super: {
      wtforms = super.wtforms.overridePythonAttrs (oldAttrs: rec {
        version = "2.3.1";
        pname = "WTForms";

        src = super.fetchPypi {
          inherit pname version;
          sha256 = "sha256-hhoTs65SHWcA2sOydxlwvTVKY7pwQ+zDqCtSiFlqGXI=";
        };

        doCheck = false;
      });
    })
  ];

  mkOverride = attrname: version: sha256:
    self: super: {
      ${attrname} = super.${attrname}.overridePythonAttrs (oldAttrs: {
        inherit version;
        src = oldAttrs.src.override {
          inherit version sha256;
        };
      });
    };

  py = python3.override {
    # Put packageOverrides at the start so they are applied after defaultOverrides
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) defaultOverrides;
  };

in
with py.pkgs;

buildPythonApplication rec {
  pname = "archivy";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UNGl5Dl/E3+uQ4HIxzHYliHF4lqD3GYdeoL+DtqUwCo=";
  };

  # Relax some dependencies
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'WTForms ==' 'WTForms >=' \
      --replace 'attrs == 20.2.0' 'attrs' \
      --replace 'elasticsearch ==' 'elasticsearch >=' \
      --replace 'python_dotenv ==' 'python_dotenv >=' \
      --replace 'python_frontmatter == 0.5.0' 'python_frontmatter' \
      --replace 'requests ==' 'requests >=' \
      --replace 'validators ==' 'validators >=' \
      --replace 'tinydb ==' 'tinydb >=' \
      --replace 'Flask_WTF == 0.14.3' 'Flask_WTF' \
      --replace 'Flask ==' 'Flask >='
  '';

  propagatedBuildInputs = [
    appdirs
    attrs
    beautifulsoup4
    click-plugins
    elasticsearch
    flask-compress
    flask_login
    flask_wtf
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
