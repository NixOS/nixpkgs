{ stdenv, python3, makeDesktopItem }:

let

  spyder-kernels = with python3.pkgs; buildPythonPackage rec {
    pname = "spyder-kernels";
    version = "0.4.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "a13cefb569ef9f63814cb5fcf3d0db66e09d2d7e6cc68c703d5118b2d7ba062b";
    };

    propagatedBuildInputs = [
      cloudpickle
      ipykernel
      wurlitzer
    ];

    # No tests
    doCheck = false;

    meta = {
      description = "Jupyter kernels for Spyder's console";
      homepage = https://github.com/spyder-ide/spyder-kernels;
      license = stdenv.lib.licenses.mit;
    };
  };

in python3.pkgs.buildPythonApplication rec {
  pname = "spyder";
  version = "3.3.3";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "ef31de03cf6f149077e64ed5736b8797dbd278e3c925e43f0bfc31bb55f6e5ba";
  };

  propagatedBuildInputs = with python3.pkgs; [
    jedi pycodestyle psutil pyflakes rope numpy scipy matplotlib pylint keyring
    numpydoc qtconsole qtawesome nbconvert mccabe pyopengl cloudpickle spyder-kernels
  ];

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
    mkdir -p $out/share/icons
    cp spyder/images/spyder.svg $out/share/icons
    cp -r $desktopItem/share/applications/ $out/share
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
