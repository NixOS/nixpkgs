{ stdenv
, lib
, fetchurl
, python3
, python3Packages
, nodePackages
, wkhtmltopdf
, callPackage
}:

with python3Packages;

let
  werkzeug = python3Packages.callPackage ../../../development/python-modules/werkzeug/1.nix {};
in

buildPythonApplication rec {
  pname = "odoo";

  major = "15";
  minor = "0";
  patch = "20220126";

  version = "${major}.${minor}.${patch}";

  # latest release is at https://github.com/odoo/docker/blob/master/15.0/Dockerfile
  src = fetchurl {
    url = "https://nightly.odoo.com/${major}.${minor}/nightly/src/odoo_${version}.tar.gz";
    name = "${pname}-${version}";
    hash = "sha256-mofV0mNCdyzJecp0XegZBR/5NzHjis9kbpsUA/KJbZg=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    mock
  ];

  buildInputs = [
    wkhtmltopdf
    nodePackages.rtlcss
  ];

  # needs some investigation
  doCheck = false;

  makeWrapperArgs = [ "--prefix" "PATH" ":" "${lib.makeBinPath [ wkhtmltopdf nodePackages.rtlcss ]}" ];

  propagatedBuildInputs = [
    Babel
    chardet
    decorator
    docutils
    ebaysdk
    freezegun
    gevent
    greenlet
    html2text
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
    ldap
    python-stdnum
    pytz
    pyusb
    qrcode
    reportlab
    requests
    vobject
    werkzeug
    xlrd
    XlsxWriter
    xlwt
    zeep
  ];

  unpackPhase = ''
    tar xfz $src
    cd odoo*
  '';

  meta = with lib; {
    description = "Open Source ERP and CRM";
    homepage = "https://www.odoo.com/";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
