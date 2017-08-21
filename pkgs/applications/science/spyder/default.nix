{ stdenv, fetchurl, unzip, buildPythonApplication, makeDesktopItem
# mandatory
, pyside
# recommended
, pyflakes ? null, rope ? null, sphinx ? null, numpy ? null, scipy ? null, matplotlib ? null
# optional
, ipython ? null, pylint ? null, pep8 ? null
}:

buildPythonApplication rec {
  name = "spyder-${version}";
  version = "2.3.8";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/s/spyder/${name}.zip";
    sha256 = "99fdae2cea325c0f2842c77bd67dd22db19fef3d9c0dde1545b1a2650eae517e";
  };

  # NOTE: sphinx makes the build fail with: ValueError: ZIP does not support timestamps before 1980
  propagatedBuildInputs =
    [ pyside pyflakes rope  numpy scipy matplotlib ipython pylint pep8 ];

  # There is no test for spyder
  doCheck = false;

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
    mkdir -p $out/share/{applications,icons}
    cp  $desktopItem/share/applications/* $out/share/applications/
    cp  spyderlib/images/spyder.svg $out/share/icons/
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
  };
}
