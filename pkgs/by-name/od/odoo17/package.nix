{
  lib,
  fetchgit,
  fetchzip,
  fetchpatch2,
  python311,
  rtlcss,
  wkhtmltopdf,
  nixosTests,
}:

let
  odoo_version = "17.0";
  odoo_release = "20250506";
  python = python311.override {
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
    hash = "sha256-V15Oe3AOBJ1agt5WmpFZnC7EkyoKyxTH8Iqdf2/9aec="; # odoo
  };
  patches = [
    (fetchpatch2 {
      url = "https://github.com/odoo/odoo/commit/ade3200e8138a9c28eb9b294a4efd2753a8e5591.patch?full_index=1";
      hash = "sha256-EFKjrR38eg9bxlNmRNoLSXem+MjQKqPcR3/mSgs0cDs=";
    })
  ];

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
      inherit (nixosTests) odoo17;
    };
  };

  meta = {
    description = "Open Source ERP and CRM";
    homepage = "https://www.odoo.com/";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      mkg20001
      siriobalmelli
    ];
  };
}
