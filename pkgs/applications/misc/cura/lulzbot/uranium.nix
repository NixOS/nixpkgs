{ lib, callPackage, fetchurl, fetchFromGitLab, buildPythonPackage, fetchFromGitHub, python36, cmake
, pyqt5, numpy, scipy_1_4, shapely, libarcusLulzbot, doxygen, gettext, pythonOlder }:

buildPythonPackage rec {
  version = "3.6.21";
  pname = "uranium";
  name = "uraniumLulzbot";
  format = "other";

  src = fetchFromGitLab {
    group = "lulzbot3d";
    owner = "cura-le";
    repo = "Uranium";
    rev = "v${version}";
    sha256 = "04bym3vwikaxw8ab0mymv9sc9n8i7yw5kfsv99ic811g9lzz3j1i";
  };

  disabled = pythonOlder "3.5.0";

  buildInputs = [ python36 gettext ];
  propagatedBuildInputs = [ pyqt5 numpy scipy_1_4 shapely libarcusLulzbot ];
  nativeBuildInputs = [ cmake doxygen ];

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i \
     -e "s,Resources.addSearchPath(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,Resources.addSearchPath(\"$out/share/uranium/resources\")," \
     -e "s,self._plugin_registry.addPluginLocation(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,self._plugin_registry.addPluginLocation(\"$out/lib/uranium/plugins\")," \
     UM/Application.py
  '';

  meta = with lib; {
    description = "A Python framework for building Desktop applications";
    homepage = "https://gitlab.com/lulzbot3d/cura-le/uranium";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}

