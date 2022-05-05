{ lib
, stdenv
, python3
, fetchPypi
}:

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
  version = "1.7.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o5dVJDbdKgo6hMMU9mKzoouSgVWl7xSAp+Aq61VcfeU=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = true;

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
