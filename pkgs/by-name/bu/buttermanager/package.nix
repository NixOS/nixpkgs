{
  lib,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsHook3,
  qt5,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "buttermanager";
  version = "2.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "egara";
    repo = "buttermanager";
    tag = finalAttrs.version;
    hash = "sha256-/U5IVJvYCw/YzBWjQ949YP9uoxsTNRJ5FO7rrI6Cvhs=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyqt5
    pyyaml
    sip
    tkinter
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    qt5.wrapQtAppsHook
  ];

  dontWrapQtApps = true;
  dontWrapGApps = true;
  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
    "\${gappsWrapperArgs[@]}"
  ];

  postInstall = ''
    substituteInPlace packaging/buttermanager.desktop \
      --replace-fail /opt/buttermanager/gui/buttermanager.svg buttermanager

    install -Dm444 packaging/buttermanager.desktop -t $out/share/applications
    install -Dm444 packaging/buttermanager.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  meta = {
    description = "Btrfs tool for managing snapshots, balancing filesystems and upgrading the system safetly";
    homepage = "https://github.com/egara/buttermanager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ t4ccer ];
    mainProgram = "buttermanager";
  };
})
