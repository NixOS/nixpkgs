{ stdenv, fetchurl, pkgs, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.4.1";
  name = "khard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "09yibjzly711hwpg345n653rz47llvrj4shnlcxd8snzvg8m5gri";
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
