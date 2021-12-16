{ lib, stdenv, python3, fetchPypi }:

let
  defaultOverrides = [
    (self: super: {
      flask = super.flask.overridePythonAttrs (oldAttrs: rec {
        version = "1.1.2";
        pname = "Flask";

        src = super.fetchPypi {
          inherit pname version;
          sha256 = "sha256-Tvoa4tfJhlr0iYbeiuuFBL8yx/PW/ck1PTSyH0sScGA=";
        };

        checkInputs = [ self.pytest ];
        propagatedBuildInputs = with self; [ itsdangerous click werkzeug jinja2 ];

        doCheck = false;
      });
    })

    (self: super: {
      flask_login = super.flask_login.overridePythonAttrs (oldAttrs: rec {
        pname = "Flask";
        version = "0.5.0";

        src = fetchPypi {
          inherit pname version;
          sha256 = "6d33aef15b5bcead780acc339464aae8a6e28f13c90d8b1cf9de8b549d1c0b4b";
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
    packageOverrides = lib.foldr lib.composeExtensions (self: super: { }) (defaultOverrides);
  };

in
with py.pkgs;

buildPythonApplication rec {
  pname = "archivy";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-97ACQ3qp9ciw0kHwKwmatzCBl4XZr+6poejBM/0D4k8=";
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
      --replace 'Werkzeug ==' 'Werkzeug >='
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
    requests
    setuptools
    tinydb
    validators
    werkzeug
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
