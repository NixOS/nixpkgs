{ stdenv, fetchurl, pkgs, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "0.8.1";
  name = "khard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "13axfrs96isirx0c483545xdmjwwfq1k7yy92xpk7l184v71rgi1";
  };

  propagatedBuildInputs = with python2Packages; [
    atomicwrites
    configobj
    vobject
    argparse
    pyyaml
  ];

  meta = {
    homepage = https://github.com/scheibler/khard;
    description = "Console carddav client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
