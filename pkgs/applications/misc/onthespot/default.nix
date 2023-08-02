{ lib
, python3
, fetchFromGitHub
, copyDesktopItems
, wrapQtAppsHook
, makeDesktopItem
}:

python3.pkgs.buildPythonApplication rec {
  pname = "onthespot";
  version = "0.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "casualsnek";
    repo = "onthespot";
    rev = "v${version}";
    hash = "sha256-VaJBNsT7uNOGY43GnzhUqDQNiPoFZcc2UaIfOKgkufg=";
  };

  nativeBuildInputs = with python3.pkgs; [
    copyDesktopItems
    pythonRelaxDepsHook
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    charset-normalizer
    defusedxml
    librespot
    music-tag
    packaging
    pillow
    protobuf
    pyogg
    pyqt5
    pyqt5_sip
    pyxdg
    requests
    setuptools
    show-in-file-manager
    urllib3
    zeroconf
  ];

  pythonRemoveDeps = [
    "PyQt5-Qt5"
    "PyQt5-stubs"
  ];

  pythonRelaxDeps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = " QT based Spotify music downloader written in Python";
    homepage = "https://github.com/casualsnek/onthespot";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.linux;
  };
}
