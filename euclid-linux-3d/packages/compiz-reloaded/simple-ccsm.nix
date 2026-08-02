{ lib, stdenv, fetchurl, python3, python3Packages, pkg-config, intltool, gettext }:

python3Packages.buildPythonApplication rec {
  pname = "simple-ccsm";
  version = "0.8.18";
  pyproject = false;

  src = fetchurl {
    url = "https://gitlab.com/compiz/simple-ccsm/-/archive/v0.8.18/simple-ccsm-v0.8.18.tar.gz";
    hash = "sha256-w0TwVKlzafmp3r5HGpM42HuzzwuX25TmEH7BxZF5524=";
  };

  nativeBuildInputs = [ pkg-config intltool gettext python3Packages.setuptools ];

  propagatedBuildInputs = [
    python3Packages.pygobject3
  ];

  prePatch = ''
    sed -i 's/from distutils.core import setup/from setuptools import setup/g' setup.py
  '';

  installPhase = ''
    python setup.py install --prefix=$out
  '';

  meta = {
    description = "Simple CompizConfig Settings Manager";
    homepage = "https://gitlab.com/compiz/simple-ccsm";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
