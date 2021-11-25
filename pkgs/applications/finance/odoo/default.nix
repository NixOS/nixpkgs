{ stdenv
, lib
, fetchurl
, python3
, python3Packages
, nodePackages
, wkhtmltopdf
}:

with python3Packages;

buildPythonApplication rec {
  pname = "odoo";

  major = "15";
  minor = "0";
  patch = "20211029";

  version = "${major}.${minor}.${patch}";

  # latest release is at https://github.com/odoo/docker/blob/master/15.0/Dockerfile
  src = fetchurl {
    url = "https://nightly.odoo.com/${major}.${minor}/nightly/src/odoo_${version}.tar.gz";
    name = "${pname}-${version}";
    sha256 = "sha256-/E+bLBbiz7fRyTwP+0AMpqbuRkOpE4B4P6kREIB4m1Q=";
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
    werkzeug1
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
    maintainers = [ maintainers.mkg20001 ];
  };
}
