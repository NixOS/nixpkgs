{ stdenv, fetchurl, glibcLocales, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.11.1";
  name = "khard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "0055xx9icmsr6l7v0iqrndmygygdpdv10550w6pyrb96svzhry27";
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
