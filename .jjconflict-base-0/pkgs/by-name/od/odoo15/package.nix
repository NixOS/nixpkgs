{
  lib,
  fetchFromGitHub,
  fetchzip,
  python310,
  rtlcss,
  wkhtmltopdf,
  nixosTests,
}:

let
  odoo_version = "15.0";
  odoo_release = "20241010";
  python = python310.override {
    self = python;
    packageOverrides = self: super: {
      pypdf2 = super.pypdf2.overridePythonAttrs (old: rec {
        version = "1.28.6";

        src = fetchFromGitHub {
          owner = "py-pdf";
          repo = "pypdf";
          rev = version;
          fetchSubmodules = true;
          hash = "sha256-WnRbsy/PJcotZqY9mJPLadrYqkXykOVifLIbDyNf4s4=";
        };

        dependencies = [ self.setuptools ];

        nativeCheckInputs = with self; [
          pytestCheckHook
          pillow
        ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "odoo";
  version = "${odoo_version}.${odoo_release}";

  format = "setuptools";

  # latest release is at https://github.com/odoo/docker/blob/5fb6a842747c296099d9384587cd89640eb7a615/15.0/Dockerfile#L58
  src = fetchzip {
    url = "https://nightly.odoo.com/${odoo_version}/nightly/src/odoo_${version}.zip";
    name = "odoo-${version}";
    hash = "sha256-Hkre6mghEiLrDwfB1BxGbqEm/zruHLwaS+eIFQKjl1o="; # odoo
  };

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      wkhtmltopdf
      rtlcss
    ]}"
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
    lxml-html-clean
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
    tests = { inherit (nixosTests) odoo15; };
  };

  meta = with lib; {
    description = "Open Source ERP and CRM";
    homepage = "https://www.odoo.com/";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
