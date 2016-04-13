{ stdenv, pythonPackages, fetchurl }:
pythonPackages.buildPythonApplication rec {
  name = "bleachbit-${version}";
  version = "1.8";

  namePrefix = "";

  src = fetchurl {
    url = "mirror://sourceforge/bleachbit/bleachbit-1.8.tar.bz2";
    sha256 = "dbf50fcbf24b8b3dd1c4325cd62352628d089f88a76eab804df5d90c872ee592";
  };

  buildInputs = [  pythonPackages.wrapPython ];

  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    cp bleachbit.py $out/bin/bleachbit
    chmod +x $out/bin/bleachbit

    substituteInPlace $out/bin/bleachbit --replace "#!/usr/bin/env python" "#!${pythonPackages.python.interpreter}"
  '';

  propagatedBuildInputs = with pythonPackages; [ pygtk sqlite3 ];

  meta = {
    homepage = "http://bleachbit.sourceforge.net";
    description = "A program to clean your computer";
    longDescription = "BleachBit helps you easily clean your computer to free space and maintain privacy.";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ leonardoce ];
  };
}
