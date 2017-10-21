{ stdenv, pythonPackages, fetchurl }:
pythonPackages.buildPythonApplication rec {
  name = "bleachbit-${version}";
  version = "1.12";

  namePrefix = "";

  src = fetchurl {
    url = "mirror://sourceforge/bleachbit/${name}.tar.bz2";
    sha256 = "1x58n429q1c77nfpf2g3vyh6yq8wha69zfzmxf1rvjvcvvmqs62m";
  };

  buildInputs = [  pythonPackages.wrapPython ];

  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    cp bleachbit.py $out/bin/bleachbit
    chmod +x $out/bin/bleachbit

    substituteInPlace $out/bin/bleachbit --replace "#!/usr/bin/env python" "#!${pythonPackages.python.interpreter}"
  '';

  propagatedBuildInputs = with pythonPackages; [ pygtk ];

  meta = {
    homepage = http://bleachbit.sourceforge.net;
    description = "A program to clean your computer";
    longDescription = "BleachBit helps you easily clean your computer to free space and maintain privacy.";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ leonardoce ];
  };
}
