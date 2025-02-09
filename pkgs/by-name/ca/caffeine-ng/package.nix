{
  fetchFromGitea,
  meson,
  ninja,
  pkg-config,
  scdoc,
  gobject-introspection,
  lib,
  libayatana-appindicator,
  libnotify,
  python3Packages,
  procps,
  xset,
  xautolock,
  xscreensaver,
  xfce,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "caffeine-ng";
  version = "4.2.0";
  format = "other";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "WhyNotHugo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uYzLRZ+6ZgIwhSuJWRBpLYHgonX7sFXgUZid0V26V0Q=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libayatana-appindicator
    libnotify
  ];

  pythonPath = with python3Packages; [
    click
    dbus-python
    ewmh
    pulsectl
    pygobject3
    scdoc
    setproctitle
  ];

  dontWrapGApps = true;

  patches = [
    ./fix-build.patch
  ];

  postPatch = ''
    echo "${version}" > version
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          procps
          xautolock
          xscreensaver
          xfce.xfconf
          xset
        ]
      }
    )
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    mainProgram = "caffeine";
    maintainers = with maintainers; [ marzipankaiser ];
    description = "Status bar application to temporarily inhibit screensaver and sleep mode";
    homepage = "https://codeberg.org/WhyNotHugo/caffeine-ng";
    changelog = "https://codeberg.org/WhyNotHugo/caffeine-ng/src/tag/v${version}/CHANGELOG.rst";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
