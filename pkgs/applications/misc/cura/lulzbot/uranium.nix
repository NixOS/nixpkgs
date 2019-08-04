{ stdenv, callPackage, fetchurl, fetchgit, buildPythonPackage, fetchFromGitHub, python, cmake
, pyqt5, numpy, scipy, shapely, libarcusLulzbot, doxygen, gettext, pythonOlder }:

buildPythonPackage rec {
  version = "3.6.18";
  pname = "uranium";
  name = "uraniumLulzbot";
  format = "other";

  src = fetchgit {
    url = https://code.alephobjects.com/diffusion/U/uranium.git;
    rev = "33df88a7414375ac924ac761113baa48d2ced2b4";
    sha256 = "109cbv7y105crbrzfp70lmcr9n20ap5c97i5qd46fmxbx86yj7f8";
  };

  disabled = pythonOlder "3.5.0";

  buildInputs = [ python gettext ];
  propagatedBuildInputs = [ pyqt5 numpy scipy shapely libarcusLulzbot ];
  nativeBuildInputs = [ cmake doxygen ];

  # Qt 5.12+ support; see https://code.alephobjects.com/rU70b73ba0a270799b9eacf78e400aa8b8ab3fb2ee
  patches = [ ./uranium-qt512-support.patch ];

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i \
     -e "s,Resources.addSearchPath(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,Resources.addSearchPath(\"$out/share/uranium/resources\")," \
     -e "s,self._plugin_registry.addPluginLocation(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,self._plugin_registry.addPluginLocation(\"$out/lib/uranium/plugins\")," \
     UM/Application.py
  '';

  meta = with stdenv.lib; {
    description = "A Python framework for building Desktop applications";
    homepage = https://code.alephobjects.com/diffusion/U/;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}

