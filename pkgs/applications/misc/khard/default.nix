{ stdenv, fetchurl, pkgs, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.4.0";
  name = "khard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "0xvg8725297faw5mk7ka4xjc968vq3ix7izd4vmsaqysl43gnh21";
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
