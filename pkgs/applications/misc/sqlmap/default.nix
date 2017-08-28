{ stdenv, pythonPackages, pkgs }:

pythonPackages.buildPythonPackage {
  name = "sqlmap-1.1";

  disabled = pythonPackages.isPy3k;

  src = pkgs.fetchurl {
    url = "mirror://pypi/s/sqlmap/sqlmap-1.1.tar.gz";
    sha256 = "0px72p52w76cylr68i69kz0kagmbrslgx2221yi77322fih0mngi";
  };

  meta = with pkgs.stdenv.lib; {
    homepage = "http://sqlmap.org";
    license = licenses.gpl2;
    description = "Automatic SQL injection and database takeover tool";
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
  };
}
