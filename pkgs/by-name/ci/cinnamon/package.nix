{
  at-spi2-core,
  atk,
  cacert,
  dbus,
  cinnamon-control-center,
  cinnamon-desktop,
  cinnamon-menus,
  cinnamon-session,
  cinnamon-translations,
  cjs,
  evolution-data-server,
  fetchFromGitHub,
  gcr_3,
  gdk-pixbuf,
  gettext,
  glib,
  gobject-introspection,
  gsound,
  gtk3,
  gtk4,
  gtk4-layer-shell,
  ibus,
  iso-flags-png-320x240,
  json-glib,
  libsecret,
  libstartup_notification,
  libxcomposite,
  libxext,
  libxtst,
  libxdamage,
  libgbm,
  muffin,
  networkmanager,
  pkg-config,
  polkit,
  lib,
  stdenv,
  wrapGAppsHook3,
  gtk-doc,
  python3,
  keybinder3,
  cairo,
  xapp,
  upower,
  nemo,
  libnotify,
  accountsservice,
  gnome-online-accounts,
  glib-networking,
  graphene,
  pciutils,
  timezonemap,
  libnma,
  meson,
  ninja,
  gst_all_1,
  pam,
  perl,
  xdotool,
  xkeyboard_config,
}:

let
  pythonEnv = python3.withPackages (
    pp: with pp; [
      setproctitle
      pygobject3
      pycairo
      python-xapp
      pillow
      pyinotify # for looking-glass
      babel
      tinycss2
      xkbcommon
      python-pam
      pexpect
      distro
      requests
      # https://github.com/NixOS/nixpkgs/issues/129946
      (toPythonModule xapp)
    ]
  );

  pythonScriptsToPatch = [
    # https://github.com/NixOS/nixpkgs/issues/200397
    "bin/cinnamon-spice-updater"
    "bin/cinnamon-install-spice"
    "share/cinnamon/cinnamon-settings/cinnamon-settings.py"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cinnamon";
  version = "6.8.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    tag = finalAttrs.version;
    hash = "sha256-Rvqgx/kIqiKc5IQzHmU+c5YbOUI+7fYNDmU2sRGu0dw=";
  };

  patches = [
    ./use-sane-install-dir.patch
    ./libdir.patch
  ];

  buildInputs = [
    at-spi2-core
    atk
    cacert
    cinnamon-control-center
    cinnamon-desktop
    cinnamon-menus
    cjs
    dbus
    evolution-data-server # for calendar-server
    gcr_3
    gdk-pixbuf
    glib
    graphene
    gsound
    gtk3
    gtk4 # for cinnamon-background-daemon
    gtk4-layer-shell
    ibus
    json-glib
    libsecret
    libstartup_notification
    libxcomposite
    libxext
    libxtst
    libxdamage
    libgbm
    muffin
    networkmanager
    pam
    polkit
    pythonEnv
    gst_all_1.gstreamer

    # bindings
    cairo
    keybinder3
    upower
    xapp
    xdotool
    timezonemap
    nemo
    libnotify
    accountsservice
    libnma

    # gsi bindings
    gnome-online-accounts
    glib-networking # for goa
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    wrapGAppsHook3
    gtk-doc
    perl
    python3.pkgs.libsass # for pysassc
    python3.pkgs.wrapPython
    pkg-config
  ];

  postPatch = ''
    find . -type f ! -name meson.build -exec sed -i \
      -e s,/usr/share/cinnamon,$out/share/cinnamon,g \
      -e s,/usr/share/locale,/run/current-system/sw/share/locale,g \
      -e s,/usr/share/iso-flag-png,${iso-flags-png-320x240}/share/iso-flags-png,g \
      {} +

    # All optional and may introduce circular dependency.
    find ./files/usr/share/cinnamon/applets -type f -exec sed -i \
      -e '/^#/!s,/usr/bin,/run/current-system/sw/bin,g' \
      {} +

    pushd ./files/usr/share/cinnamon/cinnamon-settings
      substituteInPlace ./bin/AddKeyboardLayout.py        --replace-fail "/usr/share/X11/xkb" "${xkeyboard_config}/share/X11/xkb"
      substituteInPlace ./bin/capi.py                     --replace-fail '"/usr/lib"' '"${cinnamon-control-center}/lib"'
      substituteInPlace ./bin/SettingsWidgets.py          --replace-fail "/usr/share/sounds" "/run/current-system/sw/share/sounds"
      substituteInPlace ./bin/Spices.py                   --replace-fail "subprocess.run(['/usr/bin/" "subprocess.run(['"
      substituteInPlace ./modules/cs_info.py              --replace-fail "lspci" "${pciutils}/bin/lspci"
      substituteInPlace ./modules/cs_themes.py            --replace-fail "$out/share/cinnamon/styles.d" "/run/current-system/sw/share/cinnamon/styles.d"
      substituteInPlace ./modules/cs_user.py              --replace-fail "/usr/bin/passwd" "/run/wrappers/bin/passwd"
    popd

    substituteInPlace ./files/usr/bin/cinnamon-session-cinnamon \
      --replace-fail "exec cinnamon-session" "exec ${cinnamon-session}/bin/cinnamon-session"

    substituteInPlace ./python3/cinnamon/harvester.py \
      --replace-fail "/usr/bin/msgfmt" "${gettext}/bin/msgfmt"

    substituteInPlace files/usr/share/cinnamon/cinnamon-menu-editor/cme/config.py \
      --replace-fail "/usr/share" "$out/share"

    patchShebangs src/data-to-c.pl
  '';

  postInstall = ''
    # Use locales from cinnamon-translations.
    ln -s ${cinnamon-translations}/share/locale $out/share/locale
  '';

  preFixup = ''
    buildPythonPath "$out"
    ${lib.concatMapStringsSep "\n" (script: "patchPythonScript $out/${script}") pythonScriptsToPatch}

    # Called as `pkexec cinnamon-settings-users.py`.
    wrapGApp $out/share/cinnamon/cinnamon-settings-users/cinnamon-settings-users.py
  '';

  passthru = {
    providedSessions = [
      "cinnamon"
      "cinnamon-wayland"
    ];
  };

  meta = {
    homepage = "https://github.com/linuxmint/cinnamon";
    description = "Cinnamon desktop environment";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
