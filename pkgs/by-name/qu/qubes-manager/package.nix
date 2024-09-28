{
  stdenv,
  fetchFromGitHub,
  python3,
  qt5,
}: let
  inherit (python3.pkgs) buildPythonApplication pyqt5 setuptools qubes-core-admin-client qasync pyaml lxml;

  version = "4.3.4-1";

  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-XcegcVjyb1JoXFFIX5Sj/QlZAn1H4bONwPpX/Yd+Njc=";
  };
in

  buildPythonApplication {
    inherit version src;
    pname = "qubes-manager";

    nativeBuildInputs = [
      setuptools
      pyqt5
      qt5.qttools
      qt5.wrapQtAppsHook
    ];

    dependencies = [
      pyqt5
      qubes-core-admin-client
      qasync
      pyaml
      lxml
    ];

    preBuild = ''
      make ui res translations python $makeFlags
    '';

    installTargets = ["python_install"];

    postInstall = ''
      make install $makeFlags
      mv $out/usr/* $out
      rm -d $out/usr
    '';

    makeFlags = ["DESTDIR=$(out)" "LRELEASE_QT5=lrelease"];
    pythonImportsCheck = ["qubesmanager"];
  }
