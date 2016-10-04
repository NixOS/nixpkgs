{ stdenv, fetchhg, pkgs, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "2016-04-10-b5721f1c6f01bd168a5781652e5e3167f7f8ceb3";
  name = "beancount-${version}";
  namePrefix = "";

  src = fetchhg {
    url = "https://bitbucket.org/blais/beancount";
    rev = "b5721f1c6f01bd168a5781652e5e3167f7f8ceb3";
    sha256 = "10nv3p9cix7yp23a9hnq5163rpl8cfs3hv75h90ld57dc24nxzn2";
  };

  buildInputs = with pythonPackages; [ nose ];

  # Automatic tests cannot be run because it needs to import some local modules for tests.
  doCheck = false;
  checkPhase = ''
    nosetests
  '';

  propagatedBuildInputs = with pythonPackages; [
    beautifulsoup4
    bottle
    chardet
    dateutil
    google_api_python_client
    lxml
    ply
    python_magic
  ];

  meta = {
    homepage = http://furius.ca/beancount/;
    description = "Double-entry bookkeeping computer language";
    longDescription = ''
        A double-entry bookkeeping computer language that lets you define
        financial transaction records in a text file, read them in memory,
        generate a variety of reports from them, and provides a web interface.
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

