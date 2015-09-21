{ stdenv, fetchurl, pkgs, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.5.0";
  name = "khard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "0k3pix4zdr5jc323w63kwrfhkvmn5ijnznzfhf6rvqp05lrkyh9x";
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
