{
  stdenv,
  lib,
  autoreconfHook,
  fetchurl,
  gettext,
  glib,
  gnome-bluetooth,
  gnome-desktop,
  gnome-panel,
  gnome-session,
  gnome,
  gsettings-desktop-schemas,
  gtk3,
  ibus,
  libcanberra-gtk3,
  libpulseaudio,
  libxkbfile,
  libxml2,
  metacity,
  pkg-config,
  polkit,
  gdm,
  replaceVars,
  systemd,
  tecla,
  upower,
  pam,
  wrapGAppsHook3,
  writeTextFile,
  xkeyboard_config,
  xorg,
  nixosTests,
  runCommand,
  buildEnv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-flashback";
  version = "3.58.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-flashback/${lib.versions.majorMinor finalAttrs.version}/gnome-flashback-${finalAttrs.version}.tar.xz";
    hash = "sha256-qqI+cEJHfnQfJCebRoudIK9OwZXuQ7PTEs2q+E2YwyE=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      tecla = lib.getExe tecla;
    })
  ];

  # make .desktop Execs absolute
  postPatch = ''
    patch -p0 <<END_PATCH
    +++ data/applications/gnome-flashback.desktop.in
    @@ -4 +4 @@
    -Exec=gnome-flashback
    +Exec=$out/bin/gnome-flashback
    END_PATCH
  '';

  postInstall = ''
    rm -r $out/share/gnome-session
    rm -r $out/share/xsessions
    rm $out/libexec/gnome-flashback-metacity
  '';

  nativeBuildInputs = [
    autoreconfHook
    gettext
    libxml2
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gnome-bluetooth
    gnome-desktop
    gsettings-desktop-schemas
    gtk3
    ibus
    libcanberra-gtk3
    libpulseaudio
    libxkbfile
    xorg.libXxf86vm
    polkit
    gdm
    gnome-panel
    systemd
    upower
    pam
    xkeyboard_config
  ];

  doCheck = true;

  enableParallelBuilding = true;

  PKG_CONFIG_LIBGNOME_PANEL_LAYOUTSDIR = "${placeholder "out"}/share/gnome-panel/layouts";
  PKG_CONFIG_LIBGNOME_PANEL_MODULESDIR = "${placeholder "out"}/lib/gnome-panel/modules";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-flashback";
      versionPolicy = "odd-unstable";
    };

    mkWmApplication =
      {
        wmName,
        wmLabel,
        wmCommand,
      }:
      writeTextFile {
        name = "gnome-flashback-${wmName}-wm";
        destination = "/share/applications/${wmName}.desktop";
        text = ''
          [Desktop Entry]
          Type=Application
          Encoding=UTF-8
          Name=${wmLabel}
          Exec=${wmCommand}
          NoDisplay=true
          X-GNOME-WMName=${wmLabel}
          X-GNOME-Autostart-Phase=WindowManager
          X-GNOME-Provides=windowmanager
          X-GNOME-Autostart-Notify=false
        '';
      };

    mkGnomeSession =
      {
        wmName,
        wmLabel,
      }:
      writeTextFile {
        name = "gnome-flashback-${wmName}-gnome-session";
        destination = "/share/gnome-session/sessions/gnome-flashback-${wmName}.session";
        text = ''
          [GNOME Session]
          Name=GNOME Flashback (${wmLabel})
        '';
      };

    mkSessionForWm =
      {
        wmName,
        wmLabel,
        wmCommand,
      }:
      writeTextFile {
        name = "gnome-flashback-${wmName}-xsession";
        destination = "/share/xsessions/gnome-flashback-${wmName}.desktop";
        text = ''
          [Desktop Entry]
          Name=GNOME Flashback (${wmLabel})
          Comment=This session logs you into GNOME Flashback with ${wmLabel}
          Exec=${gnome-session}/bin/gnome-session --session=gnome-flashback-${wmName}
          TryExec=${wmCommand}
          Type=Application
          DesktopNames=GNOME-Flashback;GNOME;
        '';
      }
      // {
        providedSessions = [ "gnome-flashback-${wmName}" ];
      };

    mkSystemdTargetForWm =
      {
        wmName,
        wmLabel,
        wmCommand,
        enableGnomePanel,
      }:
      runCommand "gnome-flashback-${wmName}.target" { } (
        ''
          if [ "${wmName}" = "metacity" ]; then
            echo "Use `services.xserver.windowManager.metacity.enable` instead."
            exit 1
          fi

          mkdir -p $out/lib/systemd/user/gnome-session@gnome-flashback-${wmName}.target.d
          cp "${finalAttrs.finalPackage}/lib/systemd/user/gnome-session@gnome-flashback-metacity.target.d/session.conf" \
            "$out/lib/systemd/user/gnome-session@gnome-flashback-${wmName}.target.d/session.conf"

          substitute ${finalAttrs.finalPackage}/lib/systemd/user/gnome-session-x11@gnome-flashback-metacity.target \
            "$out/lib/systemd/user/gnome-session-x11@gnome-flashback-${wmName}.target" \
            --replace-fail "(Metacity)" "(${wmLabel})"

          echo -e "[Unit]\nWants=${wmName}.service" >> "$out/lib/systemd/user/gnome-session@gnome-flashback-${wmName}.target.d/${wmName}.conf"

          substitute ${metacity}/lib/systemd/user/metacity.service \
            "$out/lib/systemd/user/${wmName}.service" \
            --replace-fail "Description=Metacity" "Description=${wmLabel}" \
            --replace-fail "ExecStart=${metacity}/bin/metacity" "ExecStart=${wmCommand}"
        ''
        + lib.optionalString (!enableGnomePanel) ''
          substituteInPlace "$out/lib/systemd/user/gnome-session@gnome-flashback-${wmName}.target.d/session.conf" \
            --replace-fail "Wants=gnome-panel.service" ""
        ''
      );

    tests = {
      inherit (nixosTests) gnome-flashback;
    };
  };

  meta = with lib; {
    description = "GNOME 2.x-like session for GNOME 3";
    mainProgram = "gnome-flashback";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-flashback";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-flashback/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = licenses.gpl2;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
})
