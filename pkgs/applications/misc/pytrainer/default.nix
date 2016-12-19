{ stdenv, fetchurl, pythonPackages, sqlite, gpsbabel }:

let

  # Pytrainer needs a matplotlib with GTK backend. Also ensure we are
  # using the pygtk with glade support as needed by pytrainer.
  matplotlibGtk = pythonPackages.matplotlib.override {
    enableGtk2 = true;
    pygtk = pythonPackages.pyGtkGlade;
  };

in

pythonPackages.buildPythonApplication rec {
  name = "pytrainer-${version}";
  version = "1.10.0";

  src = fetchurl {
    url = "https://github.com/pytrainer/pytrainer/archive/v${version}.tar.gz";
    sha256 = "0l42p630qhymgrcvxgry8chrpzcp6nr3d1vd7vhifh2npfq9l09y";
  };

  namePrefix = "";

  # The existing use of pywebkitgtk shows raw HTML text instead of
  # map. This patch solves the problems by showing the file from a
  # string, which allows setting an explicit MIME type.
  patches = [ ./pytrainer-webkit.patch ];

  propagatedBuildInputs = with pythonPackages; [
    dateutil lxml matplotlibGtk pyGtkGlade pywebkitgtk
    sqlalchemy_migrate
  ];

  buildInputs = [ gpsbabel sqlite ];

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
