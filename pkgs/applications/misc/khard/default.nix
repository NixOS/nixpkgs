{ stdenv, fetchurl, fetchFromGitHub, glibcLocales, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.12.2";
  name = "khard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "0lxcvzmafpvqcifgq2xjh1ca07z0vhihn5jnw8zrpmsqdc9p6b4j";
  };

  # setup.py reads the UTF-8 encoded readme.
  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = with python3Packages; [
    atomicwrites
    configobj
    vobject
    argparse
    ruamel_yaml
    ruamel_base
    unidecode
  ];

  # Fails; but there are no tests anyway.
  doCheck = false;

  meta = {
    homepage = https://github.com/scheibler/khard;
    description = "Console carddav client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
