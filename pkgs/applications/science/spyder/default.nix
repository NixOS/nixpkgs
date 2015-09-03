{ stdenv, fetchurl, unzip, buildPythonPackage, makeDesktopItem
# mandatory
, pyside
# recommended
, pyflakes ? null, rope ? null, sphinx ? null, numpy ? null, scipy ? null, matplotlib ? null
# optional
, ipython ? null, pylint ? null, pep8 ? null
}:

buildPythonPackage rec {
  name = "spyder-${version}";
  version = "2.3.6";
  namePrefix = "";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/s/spyder/${name}.zip";
    sha256 = "0e6502e0d3f270ea8916d1a3d7ca29915801d31932db399582bc468c01d535e2";
  };

  buildInputs = [ unzip ];
  propagatedBuildInputs =
    [ pyside pyflakes rope sphinx numpy scipy matplotlib ipython pylint pep8 ];

  # There is no test for spyder
  doCheck = false;

  # Use setuptools instead of distutils.
  preConfigure = ''
    export USE_SETUPTOOLS=True
  '';

  desktopItem = makeDesktopItem {
    name = "Spyder";
    exec = "spyder";
    icon = "spyder";
    comment = "Scientific Python Development Environment";
    desktopName = "Spyder";
    genericName = "Python IDE";
    categories = "Application;Development;Editor;IDE;";
  };

  # Create desktop item
  postInstall = ''
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications/

    mkdir -p $out/share/icons
    cp spyderlib/images/spyder.svg $out/share/icons/
  '';

  meta = with stdenv.lib; {
    description = "Scientific python development environment";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = https://github.com/spyder-ide/spyder/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
