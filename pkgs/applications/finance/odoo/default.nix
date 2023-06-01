{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, python310
, nodePackages
, wkhtmltopdf
, nixosTests
}:

let
  python = python310.override {
    packageOverrides = self: super: {
      pypdf2 = super.pypdf2.overridePythonAttrs (old: rec {
        version = "1.28.6";
        format = "setuptools";

        src = fetchFromGitHub {
          owner = "py-pdf";
          repo = "pypdf";
          rev = version;
          fetchSubmodules = true;
          hash = "sha256-WnRbsy/PJcotZqY9mJPLadrYqkXykOVifLIbDyNf4s4=";
        };

        nativeBuildInputs = [];

        nativeCheckInputs = with self; [ pytestCheckHook pillow ];
      });
      flask = super.flask.overridePythonAttrs (old: rec {
        version = "2.1.3";
        src = old.src.override {
          inherit version;
          hash = "sha256-FZcuUBffBXXD1sCQuhaLbbkCWeYgrI1+qBOjlrrVtss=";
        };
      });
      werkzeug = super.werkzeug.overridePythonAttrs (old: rec {
        version = "2.1.2";
        src = old.src.override {
          inherit version;
          hash = "sha256-HOCOgJPtZ9Y41jh5/Rujc1gX96gN42dNKT9ZhPJftuY=";
        };
      });
    };
  };

  odoo_version = "15.0";
  odoo_release = "20230317";
in python.pkgs.buildPythonApplication rec {
  pname = "odoo";
  version = "${odoo_version}.${odoo_release}";

  format = "setuptools";

  # latest release is at https://github.com/odoo/docker/blob/master/15.0/Dockerfile
  src = fetchurl {
    url = "https://nightly.odoo.com/${odoo_version}/nightly/src/odoo_${version}.tar.gz";
    name = "${pname}-${version}";
    hash = "sha256-nJEFPtZhq7DLLDCL9xt0RV75d/a45o6hBKsUlQAWh1U="; # odoo
  };

  unpackPhase = ''
    tar xfz $src
    cd odoo*
  '';

  # needs some investigation
  doCheck = false;

  makeWrapperArgs = [
    "--prefix" "PATH" ":" "${lib.makeBinPath [ wkhtmltopdf nodePackages.rtlcss ]}"
  ];

  propagatedBuildInputs = with python.pkgs; [
    babel
    chardet
    decorator
    docutils
    ebaysdk
    freezegun
    gevent
    greenlet
    idna
    jinja2
    libsass
    lxml
    markupsafe
    mock
    num2words
    ofxparse
    passlib
    pillow
    polib
    psutil
    psycopg2
    pydot
    pyopenssl
    pypdf2
    pyserial
    python-dateutil
    python-ldap
    python-stdnum
    pytz
    pyusb
    qrcode
    reportlab
    requests
    setuptools
    vobject
    werkzeug
    xlrd
    xlsxwriter
    xlwt
    zeep
  ];

  # takes 5+ minutes and there are not files to strip
  dontStrip = true;

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (nixosTests) odoo;
    };
  };

  meta = with lib; {
    description = "Open Source ERP and CRM";
    homepage = "https://www.odoo.com/";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
