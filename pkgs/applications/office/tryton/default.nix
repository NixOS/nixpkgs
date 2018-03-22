{ stdenv, fetchurl, python2Packages, librsvg }:

with stdenv.lib;

python2Packages.buildPythonApplication rec {
  name = "tryton-${version}";
  version = "4.6.2";
  src = fetchurl {
    url = "mirror://pypi/t/tryton/${name}.tar.gz";
    sha256 = "0bamr040np02gfjk8c734rw3mbgg75irfgpdcl2npgkdzyw1ksf9";
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
