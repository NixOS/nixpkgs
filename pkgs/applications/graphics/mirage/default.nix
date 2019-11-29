{ stdenv, fetchurl, pythonPackages, libX11, gettext }:

pythonPackages.buildPythonApplication rec {
    pname = "mirage";
    version = "0.9.5.2";

    src = fetchurl {
      url = "mirror://sourceforge/mirageiv/${pname}-${version}.tar.bz2";
      sha256 = "d214a1b6d99d1d1e83da5848a2cef181f6781e0990e93f7ebff5880b0c43f43c";
    };

    doCheck = false;

    nativeBuildInputs = [ gettext ];

    buildInputs = [ stdenv libX11 gettext ];

    patchPhase = ''
      sed -i "s@/usr/local/share/locale@$out/share/locale@" mirage.py
    '';

    propagatedBuildInputs = with pythonPackages; [ pygtk pillow ];

    meta = {
      description = "Simple image viewer written in PyGTK";

      homepage = http://mirageiv.sourceforge.net/;

      license = stdenv.lib.licenses.gpl2;
    };
}
