{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook4,
  gobject-introspection,
  libadwaita,
  libportal,
  libportal-gtk4,
  xdg-desktop-portal,
  xdg-desktop-portal-gtk,
}:
stdenv.mkDerivation rec {
  pname = "streamcontroller";

  # Note that the latest tagged version (1.5.0-beta.6) includes a python dependency
  # that doesn't exist anymore, so we package an unstable version instead.
  version = "1.5.0-beta.6-unstable-2024-08-13";

  src = fetchFromGitHub {
    repo = "StreamController";
    owner = "StreamController";
    rev = "dbb6460a69137af192db09d504224ae9f1127cbd";
    hash = "sha256-+YYzHLRU5MNjF3iaKIDj9k4PVg+vnEZhbc3ZmNI7xyw=";
  };

  # The installation method documented upstream
  # (https://streamcontroller.github.io/docs/latest/installation/) is to clone the repo,
  # run `pip install`, then run `python3 main.py` to launch the program.
  # Due to how the code is structured upstream, it's infeasible to use `buildPythonApplication`.

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/usr/lib/streamcontroller
    cp -r ./* $out/usr/lib/streamcontroller/

    mkdir -p $out/bin/

    # Note that the implementation of main.py assumes
    # working directory to be at the root of the project's source code
    makeWrapper \
      ${python3Packages.python.interpreter} \
      $out/bin/streamcontroller \
      --add-flags main.py \
      --chdir $out/usr/lib/streamcontroller \
      --prefix PYTHONPATH : "$PYTHONPATH"

    mkdir -p "$out/etc/udev/rules.d"
    cp ./udev.rules $out/etc/udev/rules.d/70-streamcontroller.rules

    install -D ./flatpak/icon_256.png $out/share/icons/hicolor/256x256/apps/streamcontroller.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "StreamController";
      desktopName = "StreamController";
      exec = "streamcontroller";
      icon = "streamcontroller";
      comment = "Control your Elgato Stream Decks";
      categories = [ "Utility" ];
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs =
    [
      libadwaita
      libportal
      libportal-gtk4
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ]
    ++ (with python3Packages; [
      annotated-types
      async-lru
      cairocffi
      cairosvg
      certifi
      cffi
      charset-normalizer
      click
      colorama
      contourpy
      cssselect2
      cycler
      dbus-python
      decorator
      defusedxml
      distlib
      dnspython
      evdev
      filelock
      fonttools
      fuzzywuzzy
      gcodepy
      get-video-properties
      gitdb
      idna
      imageio
      imageio-ffmpeg
      indexed-bzip2
      jinja2
      joblib
      kiwisolver
      levenshtein
      linkify-it-py
      loguru
      markdown-it-py
      markupsafe
      matplotlib
      mdit-py-plugins
      mdurl
      meson
      meson-python
      natsort
      nltk
      numpy
      opencv4
      packaging
      pillow
      platformdirs
      plumbum
      proglog
      psutil
      pulsectl
      pycairo
      pyclip
      pycparser
      pydantic
      pydantic-core
      pyenchant
      pygments
      pygobject3
      pymongo
      pyparsing
      pyperclip
      pyproject-metadata
      pyro5
      pyspellchecker
      python-dateutil
      pyudev
      pyusb
      pyyaml
      rapidfuzz
      regex
      requests
      requirements-parser
      rich
      rpyc
      serpent
      setproctitle
      six
      smmap
      speedtest-cli
      streamcontroller-plugin-tools
      streamdeck
      textual
      tinycss2
      tqdm
      types-setuptools
      typing-extensions
      uc-micro-py
      urllib3
      usb-monitor
      webencodings
      websocket-client
    ]);

  meta = with lib; {
    description = "Elegant Linux app for the Elgato Stream Deck with support for plugins";
    homepage = "https://core447.com/";
    license = licenses.gpl3;
    mainProgram = "streamcontroller";
    maintainers = with maintainers; [ sifmelcara ];
    platforms = lib.platforms.linux;
  };
}
