{ stdenv, fetchurl, python2Packages, librsvg }:

with stdenv.lib;

python2Packages.buildPythonApplication rec {
  name = "tryton-${version}";
  version = "4.2.1";
  src = fetchurl {
    url = "mirror://pypi/t/tryton/${name}.tar.gz";
    sha256 = "1ry3kvbk769m8rwqa90pplfvmmgsv4jj9w1aqhv892smia8f0ybm";
  };
  propagatedBuildInputs = with python2Packages; [
    chardet
    dateutil
    pygtk
    librsvg
  ];
  makeWrapperArgs = [
    ''--set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"''
  ];
  meta = {
    description = "The client of the Tryton application platform";
    longDescription = ''
      The client for Tryton, a three-tier high-level general purpose
      application platform under the license GPL-3 written in Python and using
      PostgreSQL as database engine.

      It is the core base of a complete business solution providing
      modularity, scalability and security.
    '';
    homepage = http://www.tryton.org/;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.johbo ];
  };
}
