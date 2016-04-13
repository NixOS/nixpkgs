{ stdenv, fetchurl, pkgs, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "0.9.0";
  name = "khard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "1cj6rlvbk05cfjkl1lnyvq12sb847jjwqy5j8906p2b2x4wq72qi";
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
