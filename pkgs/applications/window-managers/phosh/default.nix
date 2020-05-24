{ stdenv
, pkgs
, fetchFromGitLab
, substituteAll
, meson
, ninja
, pkgconfig
, wrapGAppsHook
, libhandy
, pulseaudio
, glib
, gtk3
, gnome3
, gcr
, pam
, upower
, wayland
, dbus
, xvfb_run
, phoc
, feedbackd
, squeekboard
, networkmanager
, polkit
, elogind
, libsecret
, git
, writeText
, makeWrapper
, makeDesktopItem
}:

let
  gvc = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgnome-volume-control";
    rev = "ae1a34aafce7026b8c0f65a43c9192d756fe1057";
    sha256 = "0a4qh5pgyjki904qf7qmvqz2ksxb0p8xhgl2aixfbhixn0pw6saw";
  };

  # The upstream desktop file in phosh repo points to a stub executable
  oskDesktop = makeDesktopItem {
    name = "sm.puri.OSK0";
    type = "Application";
    desktopName = "On-screen keyboard";
    exec = "${squeekboard}/bin/squeekboard";
    categories = "GNOME;Core;";
    extraEntries = ''
      OnlyShowIn=GNOME;
      NoDisplay=true
      X-GNOME-Autostart-Phase=Panel
      X-GNOME-Provides=inputmethod
      X-GNOME-Autostart-Notify=true
      X-GNOME-AutoRestart=true
    '';
  };

in stdenv.mkDerivation rec {
  pname = "phosh";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "cf51f31039d0781d965e9d57455786e635a0660d";
    sha256 = "07fw1310y5r3kgcry6ac1j2p4v2lkjy3pwxw2hkaqf67whnsh95i";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      phoc = phoc;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    phoc
    libhandy
    libsecret
    pulseaudio
    glib
    gcr
    networkmanager
    elogind
    polkit
    gnome3.gnome-control-center
    gnome3.gnome-desktop
    gnome3.gnome-session
    # https://gitlab.alpinelinux.org/alpine/aports/-/issues/11502
    gnome3.gnome-shell
    gnome3.mutter
    gtk3
    pam
    upower
    wayland
    feedbackd
  ];

  checkInputs = [
    dbus
    xvfb_run
  ];

  doCheck = true;

  postUnpack = ''
    rmdir $sourceRoot/subprojects/gvc
    ln -s ${gvc} $sourceRoot/subprojects/gvc
  '';

  checkPhase = ''
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  postFixup = ''
    mkdir -p $out/share/wayland-sessions
    ln -s $out/share/applications/sm.puri.Phosh.desktop $out/share/wayland-sessions/
    cp -r ${oskDesktop}/share/applications/sm.puri.OSK0.desktop $out/share/applications/sm.puri.OSK0.desktop
    cp -r $out/share/gsettings-schemas/phosh-${version}/glib-2.0/schemas $out/share/glib-2.0/
  '';

  passthru = {
    providedSessions = [
     "sm.puri.Phosh"
    ];
  };

  meta = with stdenv.lib; {
    description = "A pure Wayland shell prototype for GNOME on mobile devices";
    homepage = "https://source.puri.sm/Librem5/phosh";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
