{ stdenv, fetchFromGitHub, perl, python2Packages, sqlite, gpsbabel
, withWebKit ? false }:

let

  # Pytrainer needs a matplotlib with GTK backend. Also ensure we are
  # using the pygtk with glade support as needed by pytrainer.
  matplotlibGtk = python2Packages.matplotlib.override {
    enableGtk2 = true;
    pygtk = python2Packages.pyGtkGlade;
  };

in

python2Packages.buildPythonApplication rec {
  name = "pytrainer-${version}";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "pytrainer";
    repo = "pytrainer";
    rev = "v${version}";
    sha256 = "1x4f1ydjql0aisvxs5kyi9lx35b4q3768dx42fyzq1nxdwzaqyvy";
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

  propagatedBuildInputs = with python2Packages; [
    dateutil lxml matplotlibGtk pyGtkGlade sqlalchemy_migrate
  ] ++ stdenv.lib.optional withWebKit [ pywebkitgtk ];

  buildInputs = [ perl gpsbabel sqlite ];

  # This package contains no binaries to patch or strip.
  dontPatchELF = true;
  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/pytrainer/pytrainer/wiki;
    description = "Application for logging and graphing sporting excursions";
    maintainers = [ maintainers.rycee ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
