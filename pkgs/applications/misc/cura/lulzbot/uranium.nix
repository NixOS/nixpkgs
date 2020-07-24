{ stdenv, callPackage, fetchurl, fetchgit, buildPythonPackage, fetchFromGitHub, python, cmake
, pyqt5, numpy, scipy, shapely, libarcusLulzbot, doxygen, gettext, pythonOlder }:

buildPythonPackage {
  version = "3.6.21";
  pname = "uranium";
  name = "uraniumLulzbot";
  format = "other";

  src = fetchgit {
    url = "https://code.alephobjects.com/diffusion/U/uranium.git";
    rev = "54d911edd2551c5875c554928896122835a0dd6c";
    sha256 = "04bym3vwikaxw8ab0mymv9sc9n8i7yw5kfsv99ic811g9lzz3j1i";
  };

  disabled = pythonOlder "3.5.0";

  buildInputs = [ python gettext ];
  propagatedBuildInputs = [ pyqt5 numpy scipy shapely libarcusLulzbot ];
  nativeBuildInputs = [ cmake doxygen ];

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i \
     -e "s,Resources.addSearchPath(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,Resources.addSearchPath(\"$out/share/uranium/resources\")," \
     -e "s,self._plugin_registry.addPluginLocation(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,self._plugin_registry.addPluginLocation(\"$out/lib/uranium/plugins\")," \
     UM/Application.py
  '';

  meta = with stdenv.lib; {
    description = "A Python framework for building Desktop applications";
    homepage = "https://code.alephobjects.com/diffusion/U/";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}

