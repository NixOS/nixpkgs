{ fetchurl
, lib
, mkDerivationWith
, python3Packages
}:

with { inherit (python3Packages) buildPythonPackage pytestCheckHook mock Babel pyqt5 xlib pyserial appdirs wcwidth setuptools; };

mkDerivationWith buildPythonPackage rec {
    pname = "plover";
    version = "4.0.0.dev10";

    src = fetchurl {
      url    = "https://github.com/openstenoproject/plover/archive/v${version}.tar.gz";
      sha256 = "sha256-Eun+ZgmOIjYw6FS/2OGoBvYh52U/Ue0+NtIqrvV2Tqc=";
    };

    # I'm not sure why we don't find PyQt5 here but there's a similar
    # sed on many of the platforms Plover builds for
    postPatch = "sed -i /PyQt5/d setup.cfg";

    propagatedBuildInputs = [
      Babel
      pyqt5
      xlib
      pyserial
      appdirs
      wcwidth
      setuptools
    ];

    dontWrapQtApps = true;

    checkInputs = [
      pytestCheckHook
      mock
    ];

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';

    pythonImportsCheck = [ "plover" ];

    meta = with lib; {
      description = "OpenSteno Plover stenography software";
      homepage = "https://github.com/openstenoproject/plover/";
      license     = licenses.gpl2;
      maintainers = with maintainers; [ twey kovirobi ];
    };
}
