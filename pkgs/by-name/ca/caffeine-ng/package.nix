{
  fetchFromCodeberg,
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
  xfconf,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "caffeine-ng";
  version = "4.3.2";
  pyproject = false;

  src = fetchFromCodeberg {
    owner = "WhyNotHugo";
    repo = "caffeine-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eJ/0lzE5X1WFhgTAgI/SOmtxPbK7ppTk90RWobPZk2o=";
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
    echo "${finalAttrs.version}" > version
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
          xfconf
          xset
        ]
      }
    )
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    mainProgram = "caffeine";
    maintainers = with lib.maintainers; [ marzipankaiser ];
    description = "Status bar application to temporarily inhibit screensaver and sleep mode";
    homepage = "https://codeberg.org/WhyNotHugo/caffeine-ng";
    changelog = "https://codeberg.org/WhyNotHugo/caffeine-ng/src/tag/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
