{ stdenv
, lib
, fetchurl
, python39
, nodePackages
, wkhtmltopdf
, nixosTests
}:

let
  python = python39.override {
    packageOverrides = self: super: {
      click = super.click.overridePythonAttrs (old: rec {
        version = "7.1.2";
        src = old.src.override {
          inherit version;
          sha256 = "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a";
        };
      });
      flask = super.flask.overridePythonAttrs (old: rec {
        version = "1.1.4";
        src = old.src.override {
          inherit version;
          sha256 = "0fbeb6180d383a9186d0d6ed954e0042ad9f18e0e8de088b2b419d526927d196";
        };
      });
      itsdangerous = super.itsdangerous.overridePythonAttrs (old: rec {
        version = "1.1.0";
        src = old.src.override {
          inherit version;
          sha256 = "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19";
        };
      });
      jinja2 = super.jinja2.overridePythonAttrs (old: rec {
        version = "2.11.3";
        src = old.src.override {
          inherit version;
          sha256 = "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6";
        };
      });
      markupsafe = super.markupsafe.overridePythonAttrs (old: rec {
        version = "2.0.1";
        src = old.src.override {
          inherit version;
          sha256 = "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a";
        };
      });
      werkzeug = super.werkzeug.overridePythonAttrs (old: rec {
        version = "1.0.1";
        src = old.src.override {
          inherit version;
          sha256 = "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c";
        };
        checkInputs = old.checkInputs ++ (with self; [
          requests
        ]);
        disabledTests = old.disabledTests ++ [
          # ResourceWarning: unclosed file
          "test_basic"
          "test_date_to_unix"
          "test_easteregg"
          "test_file_rfc2231_filename_continuations"
          "test_find_terminator"
          "test_save_to_pathlib_dst"
        ];
        disabledTestPaths = old.disabledTestPaths ++ [
          # ResourceWarning: unclosed file
          "tests/test_http.py"
        ];
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "odoo";

  odoo_version = "15.0";
  odoo_release = "20220506";

  version = "${odoo_version}.${odoo_release}";

  format = "setuptools";

  # latest release is at https://github.com/odoo/docker/blob/master/15.0/Dockerfile
  src = fetchurl {
    url = "https://nightly.odoo.com/${odoo_version}/nightly/src/odoo_${version}.tar.gz";
    name = "${pname}-${version}";
    sha256 = "0mwlmfz5nhvg483ldrmlrjhwaf284c0c0pxf0fb0sfx2dnjjj3ib"; # odoo
  };

  # needs some investigation
  doCheck = false;

  makeWrapperArgs = [ "--prefix" "PATH" ":" "${lib.makeBinPath [ wkhtmltopdf nodePackages.rtlcss ]}" ];

  propagatedBuildInputs = with python.pkgs; [
    babel
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
