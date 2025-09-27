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
  fetchpatch,
  gcr,
  gdk-pixbuf,
  gettext,
  libgnomekbd,
  glib,
  gobject-introspection,
  gsound,
  gtk3,
  intltool,
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
  caribou,
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
      dbus-python
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
  version = "6.4.13";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    rev = version;
    hash = "sha256-XGG5Qf6Kx1gvZITuuZWn1ggY4FNW/aEuBLbpWyxE2V8=";
  };

  patches = [
    ./use-sane-install-dir.patch
    ./libdir.patch

    # js: Use DesktopAppInfo form GioUnix, not Gio
    # https://github.com/linuxmint/cinnamon/pull/13091
    (fetchpatch {
      url = "https://github.com/linuxmint/cinnamon/commit/fa3aef20533af4499fb1161011e62e048bbdc396.patch";
      hash = "sha256-qhgBniaUE/8q9BQ+EXcY7BF6eMJg+wC7EYgktwAMbwM=";
    })
    (fetchpatch {
      url = "https://github.com/linuxmint/cinnamon/commit/330b9ff19f33ec1e94e36048ca46011404f796b4.patch";
      hash = "sha256-YEQG6C4tx2T3wMfCLZXPFynAzEeIE1eVoadWVENZDFc=";
    })
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
    gsound
    gtk3
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
    caribou
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
    intltool
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
      substituteInPlace ./modules/cs_keyboard.py          --replace-fail "/usr/bin/cinnamon-dbus-command" "$out/bin/cinnamon-dbus-command"
      substituteInPlace ./modules/cs_themes.py            --replace-fail "$out/share/cinnamon/styles.d" "/run/current-system/sw/share/cinnamon/styles.d"
      substituteInPlace ./modules/cs_user.py              --replace-fail "/usr/bin/passwd" "/run/wrappers/bin/passwd"
    popd

    # In preFixup we make these executable.
    substituteInPlace ./files/usr/share/cinnamon/applets/printers@cinnamon.org/applet.js \
      --replace-fail "Util.spawn_async(['python3'," "Util.spawn_async(["

    substituteInPlace ./files/usr/bin/cinnamon-session-{cinnamon,cinnamon2d} \
      --replace-fail "exec cinnamon-session" "exec ${cinnamon-session}/bin/cinnamon-session"

    patchShebangs src/data-to-c.pl data/theme/parse-sass.sh
  '';

  postInstall = ''
    # Use locales from cinnamon-translations.
    ln -s ${cinnamon-translations}/share/locale $out/share/locale
  '';

  preFixup = ''
    # https://github.com/NixOS/nixpkgs/issues/101881
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${caribou}/share"
    )

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

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon";
    description = "Cinnamon desktop environment";
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
