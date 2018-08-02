{ stdenv, python2Packages
, withPostgresql ? true }:

with stdenv.lib;

python2Packages.buildPythonApplication rec {
  pname = "trytond";
  version = "4.8.2";
  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "ec5c419418517bf9f7d2af08b2bfd3bcc7526f6d6f07d122abf1699c728ae2a9";
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
    ipaddress

    # extra dependencies
    bcrypt
    pydot
    python-Levenshtein
    simplejson
    cdecimal
    html2text
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
    maintainers = with maintainers; [ udono johbo ];
  };
}
