{ lib
, stdenv
, mkDerivationWith
, fetchFromGitHub
, python3Packages
, herbstluftwm
}:

mkDerivationWith python3Packages.buildPythonApplication rec {
  inherit stdenv;

  pname = "webmacs";
  version = "0.8";

  disabled = python3Packages.isPy27;

  src = fetchFromGitHub {
    owner = "parkouss";
    repo = "webmacs";
    rev = version;
    fetchSubmodules = true;
    sha256 = "1hzb9341hybgrqcy1w20hshm6xaiby4wbjpjkigf4zq389407368";
  };

  propagatedBuildInputs = with python3Packages; [
    pyqtwebengine
    setuptools
    dateparser
    jinja2
    pygments
  ];

  nativeCheckInputs = [
    python3Packages.pytest
    #python3Packages.pytest-xvfb
    #python3Packages.pytest-qt
    python3Packages.pytestCheckHook
    herbstluftwm

    # The following are listed in test-requirements.txt but appear not
    # to be needed at present:

    # python3Packages.pytest-mock
    # python3Packages.flake8
  ];

  # See https://github.com/parkouss/webmacs/blob/1a04fb7bd3f33d39cb4d71621b48c2458712ed39/setup.py#L32
  # Don't know why they're using CC for g++.
  preConfigure = ''
   export CC=$CXX
  '';

  doCheck = false; # test dependencies not packaged up yet

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Keyboard-based web browser with Emacs/conkeror heritage";
    longDescription = ''
      webmacs is yet another browser for keyboard-based web navigation.

      It mainly targets emacs-like navigation, and started as a clone (in terms of
      features) of conkeror.

      Based on QtWebEngine and Python 3. Fully customizable in Python.
    '';
    homepage = "https://webmacs.readthedocs.io/en/latest/";
    changelog = "https://github.com/parkouss/webmacs/blob/master/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jacg ];
    platforms = platforms.all;
  };

}
