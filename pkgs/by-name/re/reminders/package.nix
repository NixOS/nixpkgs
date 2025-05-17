{
  lib,
  python3,
  fetchFromGitHub,

  meson,
  ninja,
  pkg-config,
  appstream,
  glib,
  gtk4,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,

  libadwaita,
  gsound,
  webkitgtk_6_0,
  libsecret,
}:
python3.pkgs.buildPythonApplication {
  pname = "reminders";
  # 4.0 release is pre-rebranding and still called "Remembrance"
  version = "4.0-unstable-2023-05-03";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "remindersdevs";
    repo = "Reminders";
    rev = "f649ea653b43d3ff0ef331729eb043fbb912f6f7";
    hash = "sha256-dhtspgHM+HWqDSNdF4O/NOyDGcL7aADsm0yT5MKjw3k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    appstream # `appstreamcli`
    glib # `glib-compile-schemas`
    gtk4 # `gtk-update-icon-cache`
    desktop-file-utils # `desktop-file-validate`
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    gsound
    webkitgtk_6_0
    libsecret
  ];

  strictDeps = true;

  dependencies = with python3.pkgs; [
    pygobject3
    msal
    requests
    caldav
    icalendar
    setuptools # `pkg_resources`
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postFixup = ''
    wrapPythonProgramsIn $out/libexec $out $pythonPath

    # We don't want store paths in desktop files
    desktop-file-edit --set-key Exec --set-value "reminders %U" \
      $out/share/applications/io.github.remindersdevs.Reminders.desktop
  '';

  # NOTE: `postCheck` is intentionally not used here, as the entire checkPhase
  # is skipped by `buildPythonApplication`
  # https://github.com/NixOS/nixpkgs/blob/9d4343b7b27a3e6f08fc22ead568233ff24bbbde/pkgs/development/interpreters/python/mk-python-derivation.nix#L296
  postInstallCheck = ''
    mesonCheckPhase
  '';

  meta = {
    description = "Open source reminder app";
    homepage = "https://github.com/remindersdevs/Reminders";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "reminders";
  };
}
