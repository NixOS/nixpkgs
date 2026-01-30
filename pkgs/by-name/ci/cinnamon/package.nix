{
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
  gcr,
  gdk-pixbuf,
  gettext,
  libgnomekbd,
  glib,
  gobject-introspection,
  gsound,
  gtk3,
  ibus,
  json-glib,
  libsecret,
  libstartup_notification,
  libXtst,
  libXdamage,
  libgbm,
  muffin,
  networkmanager,
  pkg-config,
  polkit,
  lib,
  stdenv,
  wrapGAppsHook3,
  libxml2,
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
  perl,
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
      pytz
      tinycss2
      python-pam
      pexpect
      distro
      requests
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "cinnamon";
  version = "6.6.6";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    tag = version;
    hash = "sha256-yOgDajTZFC566uhf9pvenAIMdDTU1JOF+ahtgPp6kTY=";
  };

  patches = [
    ./use-sane-install-dir.patch
    ./libdir.patch
  ];

  buildInputs = [
    atk
    cacert
    cinnamon-control-center
    cinnamon-desktop
    cinnamon-menus
    cjs
    dbus
    evolution-data-server # for calendar-server
    gcr
    gdk-pixbuf
    glib
    graphene
    gsound
    gtk3
    ibus
    json-glib
    libsecret
    libstartup_notification
    libXtst
    libXdamage
    libgbm
    muffin
    networkmanager
    polkit
    pythonEnv
    libxml2
    libgnomekbd
    gst_all_1.gstreamer

    # bindings
    cairo
    keybinder3
    upower
    xapp
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
    find . -type f -exec sed -i \
      -e s,/usr/share/cinnamon,$out/share/cinnamon,g \
      -e s,/usr/share/locale,/run/current-system/sw/share/locale,g \
      {} +

    # All optional and may introduce circular dependency.
    find ./files/usr/share/cinnamon/applets -type f -exec sed -i \
      -e '/^#/!s,/usr/bin,/run/current-system/sw/bin,g' \
      {} +

    pushd ./files/usr/share/cinnamon/cinnamon-settings
      substituteInPlace ./bin/capi.py                     --replace-fail '"/usr/lib"' '"${cinnamon-control-center}/lib"'
      substituteInPlace ./bin/SettingsWidgets.py          --replace-fail "/usr/share/sounds" "/run/current-system/sw/share/sounds"
      substituteInPlace ./bin/Spices.py                   --replace-fail "subprocess.run(['/usr/bin/" "subprocess.run(['" \
                                                          --replace-fail 'subprocess.run(["/usr/bin/' 'subprocess.run(["' \
                                                          --replace-fail "msgfmt" "${gettext}/bin/msgfmt"
      substituteInPlace ./modules/cs_info.py              --replace-fail "lspci" "${pciutils}/bin/lspci"
      substituteInPlace ./modules/cs_themes.py            --replace-fail "$out/share/cinnamon/styles.d" "/run/current-system/sw/share/cinnamon/styles.d"
      substituteInPlace ./modules/cs_user.py              --replace-fail "/usr/bin/passwd" "/run/wrappers/bin/passwd"
    popd

    # In preFixup we make these executable.
    substituteInPlace ./files/usr/share/cinnamon/applets/printers@cinnamon.org/applet.js \
      --replace-fail "Util.spawn_async(['python3'," "Util.spawn_async(["

    substituteInPlace ./files/usr/bin/cinnamon-session-{cinnamon,cinnamon2d} \
      --replace-fail "exec cinnamon-session" "exec ${cinnamon-session}/bin/cinnamon-session"

    patchShebangs src/data-to-c.pl
  '';

  postInstall = ''
    # Use locales from cinnamon-translations.
    ln -s ${cinnamon-translations}/share/locale $out/share/locale
  '';

  preFixup = ''
    buildPythonPath "$out ${python3.pkgs.python-xapp}"

    # https://github.com/NixOS/nixpkgs/issues/200397
    patchPythonScript $out/bin/cinnamon-spice-updater

    # https://github.com/NixOS/nixpkgs/issues/129946
    patchPythonScript $out/share/cinnamon/cinnamon-desktop-editor/cinnamon-desktop-editor.py

    # Called as `pkexec cinnamon-settings-users.py`.
    wrapGApp $out/share/cinnamon/cinnamon-settings-users/cinnamon-settings-users.py

    # postPatch touches both but we mainly want to wrap cancel-print-dialog.
    chmod +x $out/share/cinnamon/applets/printers@cinnamon.org/{cancel-print-dialog,lpstat-a}.py
    wrapGApp $out/share/cinnamon/applets/printers@cinnamon.org/cancel-print-dialog.py
  '';

  passthru = {
    providedSessions = [
      "cinnamon"
      "cinnamon2d"
      "cinnamon-wayland"
    ];
  };

  meta = {
    homepage = "https://github.com/linuxmint/cinnamon";
    description = "Cinnamon desktop environment";
    license = [ lib.licenses.gpl2 ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
}
