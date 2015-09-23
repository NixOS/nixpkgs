{ stdenv, fetchurl, pkgs, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.6.0";
  name = "khard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "1ag6p416iibwgvijjc8bwyrssxw3s3j559700xfgp10vj0nqk1hb";
  };

  propagatedBuildInputs = with pythonPackages; [
    configobj
    vobject
    argparse
  ];

  buildInputs = with pythonPackages; [
    pkgs.vdirsyncer
  ];

  meta = {
    homepage = https://github.com/scheibler/khard;
    description = "Console carddav client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
