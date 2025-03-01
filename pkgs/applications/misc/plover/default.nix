{ lib, fetchFromGitHub, python3, wmctrl, qtbase, mkDerivationWith }:

{
  stable = throw "plover.stable was removed because it used Python 2. Use plover.dev instead."; # added 2022-06-05

  dev = with python3.pkgs; mkDerivationWith buildPythonPackage rec {
    pname = "plover";
    version = "4.0.0";

    meta = with lib; {
      broken = stdenv.hostPlatform.isDarwin;
      description = "OpenSteno Plover stenography software";
      maintainers = with maintainers; [ twey kovirobi nilscc ];
      license     = licenses.gpl2;
    };

    src = fetchFromGitHub {
      owner = "openstenoproject";
      repo = "plover";
      rev = "v${version}";
      hash = "sha256-9oDsAbpF8YbLZyRzj9j5tk8QGi0o1F+8vB5YLJGqN+4=";
    };

    # I'm not sure why we don't find PyQt5 here but there's a similar
    # sed on many of the platforms Plover builds for
    postPatch = "sed -i /PyQt5/d setup.cfg";

    nativeCheckInputs     = [ pytest mock ];
    propagatedBuildInputs = [ babel pyqt5 xlib pyserial appdirs wcwidth setuptools rtf_tokenize evdev plover-stroke ];

    dontWrapQtApps = true;

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';
  };
}
