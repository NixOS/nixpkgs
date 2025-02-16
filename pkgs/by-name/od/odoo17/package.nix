{
  lib,
  fetchgit,
  fetchzip,
  python310,
  rtlcss,
  wkhtmltopdf,
  nixosTests,
}:

let
  odoo_version = "17.0";
  odoo_release = "20241010";
  python = python310.override {
    self = python;
    packageOverrides = final: prev: {
      # requirements.txt fixes docutils at 0.17; the default 0.21.1 tested throws exceptions
      docutils-0_17 = prev.docutils.overridePythonAttrs (old: rec {
        version = "0.17";
        src = fetchgit {
          url = "git://repo.or.cz/docutils.git";
          rev = "docutils-${version}";
          hash = "sha256-O/9q/Dg1DBIxKdNBOhDV16yy5ez0QANJYMjeovDoWX8=";
        };
        buildInputs = with prev; [ setuptools ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "odoo";
  version = "${odoo_version}.${odoo_release}";

  format = "setuptools";

  # latest release is at https://github.com/odoo/docker/blob/master/17.0/Dockerfile
  src = fetchzip {
    url = "https://nightly.odoo.com/${odoo_version}/nightly/src/odoo_${version}.zip";
    name = "odoo-${version}";
    hash = "sha256-s4Fvzjwl2oM0V9G1WQdSoqo7kE7b8tJdluk9f7A06e8="; # odoo
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
    cryptography
    decorator
    docutils-0_17 # sphinx has a docutils requirement >= 18
    ebaysdk
    freezegun
    geoip2
    gevent
    greenlet
    idna
    jinja2
    libsass
    lxml
    lxml-html-clean
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
    rjsmin
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
    maintainers = with maintainers; [
      mkg20001
      siriobalmelli
    ];
  };
}
