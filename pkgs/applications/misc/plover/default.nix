{ lib, fetchFromGitHub, python3Packages, wmctrl, qtbase, mkDerivationWith }:

{
  stable = throw "plover.stable was removed because it used Python 2. Use plover.dev instead."; # added 2022-06-05

  dev = with python3Packages; mkDerivationWith buildPythonPackage rec {
    pname = "plover";
    version = "4.0.0.dev10";

    meta = with lib; {
      broken = stdenv.isDarwin;
      description = "OpenSteno Plover stenography software";
      maintainers = with maintainers; [ twey kovirobi ];
      license     = licenses.gpl2;
    };

    src = fetchFromGitHub {
      owner = "openstenoproject";
      repo = "plover";
      rev = "v${version}";
      sha256 = "sha256-oJ7+R3ZWhUbNTTAw1AfMg2ur8vW1XEbsa5FgSTam1Ns=";
    };

    # I'm not sure why we don't find PyQt5 here but there's a similar
    # sed on many of the platforms Plover builds for
    postPatch = "sed -i /PyQt5/d setup.cfg";

    checkInputs           = [ pytest mock ];
    propagatedBuildInputs = [ babel pyqt5 xlib pyserial appdirs wcwidth setuptools ];

    dontWrapQtApps = true;

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';
  };
}
