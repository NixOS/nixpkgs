{ lib
, python3Packages
, fetchFromGitHub
, copyDesktopItems
, writeText
, makeDesktopItem
, wrapGAppsHook
, xvfb-run
, qt6
}:

python3Packages.buildPythonApplication rec {
  pname = "streamdeck-ui";
  version = "3.1.0";

  src = fetchFromGitHub {
    repo = "streamdeck-linux-gui";
    owner = "streamdeck-linux-gui";
    rev = "v${version}";
    sha256 = "sha256-AIE9j022L4WSlHBAu3TT5uE4Ilgk/jYSmU03K8Hs8xY=";
  };

  patches = [
    # nixpkgs has a newer pillow version
    ./update-pillow.patch
  ];

  desktopItems = let
    common = {
      name = "streamdeck-ui";
      desktopName = "Stream Deck UI";
      icon = "streamdeck-ui";
      exec = "streamdeck";
      comment = "UI for the Elgato Stream Deck";
      categories = [ "Utility" ];
    };
  in builtins.map makeDesktopItem [
    common
    (common // {
      name = "${common.name}-noui";
      exec = "${common.exec} --no-ui";
      noDisplay = true;
    })
  ];

  postInstall =
    let
      udevRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", TAG+="uaccess"
      '';
    in
      ''
        mkdir -p $out/lib/systemd/user
        substitute scripts/streamdeck.service $out/lib/systemd/user/streamdeck.service \
          --replace '<path to streamdeck>' $out/bin/streamdeck

        mkdir -p "$out/etc/udev/rules.d"
        cp ${writeText "70-streamdeck.rules" udevRules} $out/etc/udev/rules.d/70-streamdeck.rules

        mkdir -p "$out/share/pixmaps"
        cp streamdeck_ui/logo.png $out/share/pixmaps/streamdeck-ui.png
      '';

  dontWrapQtApps = true;
  dontWrapGApps = true;
  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" "\${gappsWrapperArgs[@]}"];

  format = "pyproject";

  nativeBuildInputs = [
    python3Packages.poetry-core
    copyDesktopItems
    qt6.wrapQtAppsHook
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    setuptools
    filetype
    cairosvg
    pillow
    pynput
    pyside6
    streamdeck
    xlib
  ] ++ lib.optionals stdenv.isLinux [
    qt6.qtwayland
  ];

  nativeCheckInputs = [
    xvfb-run
    python3Packages.pytest
  ];

  checkPhase = ''
    xvfb-run pytest tests
  '';

  meta = with lib; {
    description = "Linux compatible UI for the Elgato Stream Deck";
    homepage = "https://streamdeck-linux-gui.github.io/streamdeck-linux-gui/";
    license = licenses.mit;
    mainProgram = "streamdeck";
    maintainers = with maintainers; [ majiir ];
  };
}
