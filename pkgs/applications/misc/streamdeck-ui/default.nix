{ lib
, python3Packages
, fetchFromGitHub
<<<<<<< HEAD
, copyDesktopItems
, writeText
, makeDesktopItem
, xvfb-run
, qt6
=======
, fetchpatch
, copyDesktopItems
, wrapQtAppsHook
, writeText
, makeDesktopItem
, xvfb-run
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3Packages.buildPythonApplication rec {
  pname = "streamdeck-ui";
<<<<<<< HEAD
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

=======
  version = "2.0.6";

  src = fetchFromGitHub {
    repo = pname;
    owner = "timothycrosley";
    rev = "v${version}";
    sha256 = "sha256-5dk+5oefg5R68kv038gsZ2p5ixmpj/vBLBp/V7Sdos8=";
  };

  patches = [
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/timothycrosley/streamdeck-ui/commit/e271656c1f47b1619d1b942e2ebb01ab2d6a68a9.patch";
      hash = "sha256-wqYwX6eSqMnW6OG7wSprD62Dz818ayFduVrqW9E/ays=";
    })
    (fetchpatch {
      name = "update-python-xlib-0.33.patch";
      url = "https://github.com/timothycrosley/streamdeck-ui/commit/07d7fdd33085b413dd26b02d8a02820edad2d568.patch";
      hash = "sha256-PylTrbfB8RJ0+kbgJlRdcvfdahGoob8LabwhuFNsUpY=";
    })
  ];

  desktopItems = [ (makeDesktopItem {
    name = "streamdeck-ui";
    desktopName = "Stream Deck UI";
    icon = "streamdeck-ui";
    exec = "streamdeck --no-ui";
    comment = "UI for the Elgato Stream Deck";
    categories = [ "Utility" ];
    noDisplay = true;
  }) ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall =
    let
      udevRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", TAG+="uaccess"
      '';
    in
      ''
<<<<<<< HEAD
        mkdir -p $out/lib/systemd/user
        substitute scripts/streamdeck.service $out/lib/systemd/user/streamdeck.service \
          --replace '<path to streamdeck>' $out/bin/streamdeck

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        mkdir -p "$out/etc/udev/rules.d"
        cp ${writeText "70-streamdeck.rules" udevRules} $out/etc/udev/rules.d/70-streamdeck.rules

        mkdir -p "$out/share/pixmaps"
        cp streamdeck_ui/logo.png $out/share/pixmaps/streamdeck-ui.png
      '';

  dontWrapQtApps = true;
  makeWrapperArgs = [ "\${qtWrapperArgs[@]}" ];

  format = "pyproject";

  nativeBuildInputs = [
    python3Packages.poetry-core
    copyDesktopItems
<<<<<<< HEAD
    qt6.wrapQtAppsHook
=======
    wrapQtAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = with python3Packages; [
    setuptools
    filetype
    cairosvg
    pillow
    pynput
<<<<<<< HEAD
    pyside6
    streamdeck
    xlib
  ] ++ lib.optionals stdenv.isLinux [
    qt6.qtwayland
=======
    pyside2
    streamdeck
    xlib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    xvfb-run
    python3Packages.pytest
<<<<<<< HEAD
  ];

  checkPhase = ''
    xvfb-run pytest tests
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Linux compatible UI for the Elgato Stream Deck";
<<<<<<< HEAD
    homepage = "https://streamdeck-linux-gui.github.io/streamdeck-linux-gui/";
=======
    homepage = "https://timothycrosley.github.io/streamdeck-ui/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ majiir ];
  };
}
