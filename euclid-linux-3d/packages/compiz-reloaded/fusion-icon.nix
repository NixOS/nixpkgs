{ lib, stdenv, fetchurl, python3, python3Packages, pkg-config, intltool, gettext, makeWrapper }:

python3Packages.buildPythonApplication rec {
  pname = "fusion-icon";
  version = "0.2.4";
  pyproject = false;

  src = fetchurl {
    url = "https://gitlab.com/compiz/fusion-icon/-/archive/v0.2.4/fusion-icon-v0.2.4.tar.gz";
    hash = "sha256-0Km0Cu2WfXY8lc1Rk44aQk7VIHo7XadT7FU93hW3Kaw=";
  };

  nativeBuildInputs = [ pkg-config intltool gettext makeWrapper python3Packages.setuptools ];

  propagatedBuildInputs = [
    python3Packages.pygobject3
  ];

  prePatch = ''
    sed -i 's/from distutils.core import setup/from setuptools import setup/g' setup.py
    # Delete the block causing syntax error on icon cache updates
    sed -i '160,170d' setup.py
  '';

  installPhase = ''
    python setup.py install --prefix=$out
  '';

  meta = {
    description = "Compiz Fusion Icon";
    homepage = "https://gitlab.com/compiz/fusion-icon";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
