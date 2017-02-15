{ stdenv, fetchurl, fetchFromGitHub, glibcLocales, python3Packages }:

let
  vobject = python3Packages.buildPythonPackage rec {
    version = "0.9.2";
    name = "vobject-${version}";

    src = fetchFromGitHub {
      owner = "eventable";
      repo = "vobject";
      sha256 = "0zj0wplj8pry98x3g551wdhh12ric7rl6rsd6li23lzdxik82s3g";
      rev = version;
    };

    disabled = python3Packages.isPyPy;

    propagatedBuildInputs = with python3Packages; [ dateutil ];

    checkPhase = "${python3Packages.python.interpreter} tests.py";

    meta = with stdenv.lib; {
      description = "Module for reading vCard and vCalendar files";
      homepage = http://eventable.github.io/vobject/;
      license = licenses.asl20;
      maintainers = [ maintainers.matthiasbeyer ];
    };
  };
in
python3Packages.buildPythonApplication rec {
  version = "0.11.3";
  name = "khard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "0brnwg7f1qnz83q5d6bl2260wykgjhhrpcxxhr2r9gj66q5hdd69";
  };

  # setup.py reads the UTF-8 encoded readme.
  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = with python3Packages; [
    atomicwrites
    configobj
    vobject
    argparse
    pyyaml
  ];

  # Fails; but there are no tests anyway.
  doCheck = false;

  meta = {
    homepage = https://github.com/scheibler/khard;
    description = "Console carddav client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
