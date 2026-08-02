{ lib, stdenv, fetchurl, python3, python3Packages, pkg-config, intltool, gettext }:

python3Packages.buildPythonApplication rec {
  pname = "ccsm";
  version = "0.8.18";
  pyproject = false;

  src = fetchurl {
    url = "https://gitlab.com/compiz/ccsm/-/archive/v0.8.18/ccsm-v0.8.18.tar.gz";
    hash = "sha256-9DiO5IlOYTPU0RWeRE4h+7qfGNg+GWCcXYn/+hgUjJo=";
  };

  nativeBuildInputs = [ pkg-config intltool gettext python3Packages.setuptools ];

  propagatedBuildInputs = [
    python3Packages.pygobject3
  ];

  prePatch = ''
    sed -i 's/from distutils.core import setup/from setuptools import setup/g' setup.py
    # Prevent trying to run gtk-update-icon-cache in setup.py during build
    sed -i '/gtk_update_icon_cache =/d' setup.py
    sed -i '/subprocess.call/d' setup.py
    # Remove the partial list reference to avoid syntax error
    sed -i '/os.path.join(prefix, compiz_icon_path)]/d' setup.py
  '';

  installPhase = ''
    python setup.py install --prefix=$out
  '';

  meta = {
    description = "CompizConfig Settings Manager";
    homepage = "https://gitlab.com/compiz/ccsm";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
