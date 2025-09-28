{
  lib,
  config,
  fetchFromGitHub,
  python3Packages,
  wmctrl,
  qtbase,
  mkDerivationWith,
}:

{
  dev =
    with python3Packages;
    mkDerivationWith buildPythonPackage rec {
      pname = "plover";
      version = "4.0.2";
      format = "setuptools";

      meta = with lib; {
        broken = stdenv.hostPlatform.isDarwin;
        description = "OpenSteno Plover stenography software";
        maintainers = with maintainers; [
          twey
          kovirobi
        ];
        license = licenses.gpl2;
      };

      src = fetchFromGitHub {
        owner = "openstenoproject";
        repo = "plover";
        tag = "v${version}";
        sha256 = "sha256-VpQT25bl8yPG4J9IwLkhSkBt31Y8BgPJdwa88WlreA8=";
      };

      # I'm not sure why we don't find PyQt5 here but there's a similar
      # sed on many of the platforms Plover builds for
      postPatch = "sed -i /PyQt5/d setup.cfg";

      nativeCheckInputs = [
        pytest
        mock
      ];
      propagatedBuildInputs = [
        babel
        pyqt5
        xlib
        pyserial
        appdirs
        wcwidth
        setuptools
      ];

      dontWrapQtApps = true;

      preFixup = ''
        makeWrapperArgs+=("''${qtWrapperArgs[@]}")
      '';
    };
}
// lib.optionalAttrs config.allowAliases {
  stable = throw "plover.stable was removed because it used Python 2. Use plover.dev instead."; # added 2022-06-05
}
