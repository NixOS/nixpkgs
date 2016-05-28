{ stdenv, fetchhg, pkgs, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "2016-05-27-0d9321ab5322ced861bd7254af3fa81df5652ca0";
  name = "beancount-${version}";

  src = fetchhg {
    url = "https://bitbucket.org/blais/beancount";
    rev = "0d9321ab5322ced861bd7254af3fa81df5652ca0";
    sha256 = "0kav53dlmqicb1vsf9c0ail8fxjqkyq8jqna98ckd1g7mylfzvxy";
  };

  buildInputs = with pythonPackages; [ nose ];

  checkPhase = ''
    nosetests $out
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
    description = "double-entry bookkeeping computer language";
    longDescription = ''
        A double-entry bookkeeping computer language that lets you define
        financial transaction records in a text file, read them in memory,
        generate a variety of reports from them, and provides a web interface.
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

