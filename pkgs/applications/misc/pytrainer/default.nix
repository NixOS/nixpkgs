{ stdenv, fetchFromGitHub, perl, python, sqlite, gpsbabel
, withWebKit ? false }:

let

  # Pytrainer needs a matplotlib with GTK backend. Also ensure we are
  # using the pygtk with glade support as needed by pytrainer.
  matplotlibGtk = python.pkgs.matplotlib.override {
    enableGtk2 = true;
    pygtk = python.pkgs.pyGtkGlade;
  };

in

python.pkgs.buildPythonApplication rec {
  name = "pytrainer-${version}";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "pytrainer";
    repo = "pytrainer";
    rev = "v${version}";
    sha256 = "0rzf8kks96qzlknh6g3b9pjq04j7qk6rmz58scp7sck8xz9rjbwx";
  };

  namePrefix = "";

  patches = [
    # The test fails in the UTC timezone and C locale.
    ./fix-test-tz.patch

    # The existing use of pywebkitgtk shows raw HTML text instead of
    # map. This patch solves the problems by showing the file from a
    # string, which allows setting an explicit MIME type.
    ./pytrainer-webkit.patch
  ];

  postPatch = ''
    substituteInPlace ./setup.py \
      --replace "'mysqlclient'," ""
  '';

  propagatedBuildInputs = with python.pkgs; [
    dateutil lxml matplotlibGtk pyGtkGlade sqlalchemy sqlalchemy_migrate psycopg2
  ] ++ stdenv.lib.optional withWebKit [ pywebkitgtk ];

  buildInputs = [ perl gpsbabel sqlite ];

  # This package contains no binaries to patch or strip.
  dontPatchELF = true;
  dontStrip = true;

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pytrainer/pytrainer/wiki;
    description = "Application for logging and graphing sporting excursions";
    maintainers = [ maintainers.rycee ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
