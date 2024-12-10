{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchzip,
  python310,
  rtlcss,
  wkhtmltopdf,
  nixosTests,
}:

let
  python = python310.override {
    packageOverrides = self: super: {
      flask = super.flask.overridePythonAttrs (old: rec {
        version = "2.3.3";
        src = old.src.override {
          inherit version;
          hash = "sha256-CcNHqSqn/0qOfzIGeV8w2CZlS684uHPQdEzVccpgnvw=";
        };
      });
      werkzeug = super.werkzeug.overridePythonAttrs (old: rec {
        version = "2.3.7";
        src = old.src.override {
          inherit version;
          hash = "sha256-K4wORHtLnbzIXdl7butNy69si2w74L1lTiVVPgohV9g=";
        };
      });
    };
  };

  odoo_version = "16.0";
  odoo_release = "20231024";
in
python.pkgs.buildPythonApplication rec {
  pname = "odoo";
  version = "${odoo_version}.${odoo_release}";

  format = "setuptools";

  # latest release is at https://github.com/odoo/docker/blob/master/16.0/Dockerfile
  src = fetchzip {
    url = "https://nightly.odoo.com/${odoo_version}/nightly/src/odoo_${version}.zip";
    name = "${pname}-${version}";
    hash = "sha256-Ux8RfA7kWLKissBBY5wrfL+aKKw++5BxjP3Vw0JAOsk="; # odoo
  };

  # needs some investigation
  doCheck = false;

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
    cryptography
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
    urllib3
    vobject
    werkzeug
    xlrd
    xlsxwriter
    xlwt
    zeep

    setuptools
    mock
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
