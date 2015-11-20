{ stdenv, fetchurl, pkgs, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.6.3";
  name = "khard-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "1dn1v4ycgqbq8vknz1dy710asq8cizxmzaynn69xknwkpgda7fm9";
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
