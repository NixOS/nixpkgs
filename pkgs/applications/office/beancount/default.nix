{ stdenv, fetchhg, pkgs, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "2.0rc1";
  name = "beancount-${version}";
  namePrefix = "";

  src = pkgs.fetchurl {
    url = "mirror://pypi/b/beancount/${name}.tar.gz";
    sha256 = "12vlkck4q3dax9866krp6963c6d845b7inkkwrlkk4njh84n71wf";
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

