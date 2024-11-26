{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6,
}:

python3Packages.buildPythonApplication rec {
  pname = "zapzap";
  version = "5.3.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rafatosta";
    repo = "zapzap";
    rev = "refs/tags/${version}";
    hash = "sha256-UIr6EYE2Y/05a3kO6waAnf6+5gb3r5UzgKaHwDbbfZw=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtwayland
    qt6.qtsvg
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  propagatedBuildInputs = with python3Packages; [
    dbus-python
    pyqt6
    pyqt6-webengine
    pyqt6-sip
  ];

  postInstall = ''
    install -Dm555 share/applications/com.rtosta.zapzap.desktop -t $out/share/applications/
    install -Dm555 share/icons/com.rtosta.zapzap.svg -t $out/share/icons/hicolor/scalable/apps/
  '';

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "WhatsApp desktop application written in Pyqt6 + PyQt6-WebEngine.";
    homepage = "https://rtosta.com/zapzap-web/";
    mainProgram = "zapzap";
    license = licenses.gpl3Only;
    changelog = "https://github.com/rafatosta/zapzap/releases/tag/${version}";
    maintainers = [ maintainers.eymeric ];
  };
}
