{ stdenv, pkgs, fetchurl, python3Packages }:

let

  # We're building beancount here as dependency-only package because fava 0.3.0
  # depends on beancount-2.0b2, but beancount as in pkgs.beancount is from the
  # master branch of the beancount repository (as the maintainer does not
  # release versions).
  beancount = python3Packages.buildPythonPackage rec {
    version = "2.0b11";
    name = "beancount-${version}";

    src = pkgs.fetchurl {
      url = "mirror://pypi/b/beancount/${name}.tar.gz";
      sha256 = "0x7mflb6s1s0jd3pbcyf9rk19fj78spwpyb8ha7nslklfizml7qh";
    };

    buildInputs = with python3Packages; [ nose ];

    # Automatic tests cannot be run because it needs to import some local modules for tests.
    doCheck = false;
    checkPhase = ''
      nosetests
    '';

    propagatedBuildInputs = with python3Packages; [
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
  };

in
python3Packages.buildPythonApplication rec {
  version = "0.3.0";
  name = "fava-${version}";

  src = fetchurl {
    url = "https://github.com/aumayr/fava/releases/download/v${version}/beancount-fava-${version}.tar.gz";
    sha256 = "1a5ws0amy2wf9vh4rxk9vn8822zfyizfprhrlnndwfps6mxd63np";
  };

  buildInputs = with python3Packages; [ pytest ];

  checkPhase = "py.test";

  propagatedBuildInputs = with python3Packages;
    [ flask dateutil pygments livereload wheel markdown2 flaskbabel tornado
      click
      beancount-pygments-lexer ] ++
    [ beancount ];

  meta = {
    homepage = https://github.com/aumayr/fava;
    description = "Web interface for beancount";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}

