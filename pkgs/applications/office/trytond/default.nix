{ stdenv, fetchurl, python2Packages
, withPostgresql ? true }:

with stdenv.lib;

python2Packages.buildPythonApplication rec {
  name = "trytond-${version}";
  version = "4.2.1";
  src = fetchurl {
    url = "mirror://pypi/t/trytond/${name}.tar.gz";
    sha256 = "1ijjpbsf3s0s7ksbi7xgzss4jgr14q5hqsyf6d68l8hwardrwpj7";
  };

  # Tells the tests which database to use
  DB_NAME = ":memory:";

  buildInputs = with python2Packages; [
    mock
  ];
  propagatedBuildInputs = with python2Packages; ([
    dateutil
    lxml
    polib
    python-sql
    relatorio
    werkzeug
    wrapt

    # extra dependencies
    bcrypt
    pydot
    python-Levenshtein
    simplejson
  ] ++ stdenv.lib.optional withPostgresql psycopg2);
  meta = {
    description = "The server of the Tryton application platform";
    longDescription = ''
      The server for Tryton, a three-tier high-level general purpose
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
