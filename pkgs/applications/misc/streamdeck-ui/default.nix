{ lib
, python3Packages
, fetchFromGitHub
, poetry
, copyDesktopItems
, wrapQtAppsHook
, writeText
, makeDesktopItem
, xvfb-run
}:

python3Packages.buildPythonApplication rec {
  pname = "streamdeck-ui";
  version = "2.0.6";

  src = fetchFromGitHub {
    repo = pname;
    owner = "timothycrosley";
    rev = "v${version}";
    sha256 = "sha256-5dk+5oefg5R68kv038gsZ2p5ixmpj/vBLBp/V7Sdos8=";
  };

  desktopItems = [ (makeDesktopItem {
    name = "streamdeck-ui";
    desktopName = "Stream Deck UI";
    icon = "streamdeck-ui";
    exec = "streamdeck --no-ui";
    comment = "UI for the Elgato Stream Deck";
    categories = [ "Utility" ];
    noDisplay = true;
  }) ];

  postInstall =
    let
      udevRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", TAG+="uaccess"
      '';
    in
      ''
        mkdir -p "$out/etc/udev/rules.d"
        cp ${writeText "70-streamdeck.rules" udevRules} $out/etc/udev/rules.d/70-streamdeck.rules

        mkdir -p "$out/share/pixmaps"
        cp streamdeck_ui/logo.png $out/share/pixmaps/streamdeck-ui.png
      '';

  dontWrapQtApps = true;
  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  format = "pyproject";

  nativeBuildInputs = [
    poetry
    copyDesktopItems
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    setuptools
    filetype
    cairosvg
    pillow
    pynput
    pyside2
    streamdeck
    xlib
  ];

  checkInputs = [
    xvfb-run
    python3Packages.pytest
    python3Packages.hypothesis-auto
  ];

  # Ignored tests are not in a running or passing state.
  # Fixes have been merged upstream but not yet released.
  # Revisit these ignored tests on each update.
  checkPhase = ''
    xvfb-run pytest tests \
      --ignore=tests/test_api.py \
      --ignore=tests/test_filter.py \
      --ignore=tests/test_stream_deck_monitor.py
  '';

  meta = with lib; {
    description = "Linux compatible UI for the Elgato Stream Deck";
    homepage = "https://timothycrosley.github.io/streamdeck-ui/";
    license = licenses.mit;
    maintainers = with maintainers; [ majiir ];
  };
}
