{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, libhandy
, libxkbcommon
, pulseaudio
, glib
, gtk3
, gnome3
, gcr
, pam
, systemd
, upower
, wayland
, dbus
, xvfb_run
, phoc
, feedbackd
, networkmanager
, polkit
, libsecret
, writeText
}:

let
  gvc = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgnome-volume-control";
    rev = "ae1a34aafce7026b8c0f65a43c9192d756fe1057";
    sha256 = "0a4qh5pgyjki904qf7qmvqz2ksxb0p8xhgl2aixfbhixn0pw6saw";
  };

  executable = writeText "phosh" ''
    PHOC_INI=@out@/share/phosh/phoc.ini
    GNOME_SESSION_ARGS="--disable-acceleration-check --session=phosh --debug"

    if [ -f /etc/phosh/phoc.ini ]; then
      PHOC_INI=/etc/phosh/phoc.ini
    elif  [ -f /etc/phosh/rootston.ini ]; then
      # honor old configs
      PHOC_INI=/etc/phosh/rootston.ini
    fi

    # Run gnome-session through a login shell so it picks
    # variables from /etc/profile.d (XDG_*)
    [ -n "$WLR_BACKENDS" ] || WLR_BACKENDS=drm,libinput
    export WLR_BACKENDS
    exec "${phoc}/bin/phoc" -C "$PHOC_INI" \
      -E "bash -lc 'XDG_DATA_DIRS=$XDG_DATA_DIRS:\$XDG_DATA_DIRS ${gnome3.gnome-session}/bin/gnome-session $GNOME_SESSION_ARGS'"
  '';

in stdenv.mkDerivation rec {
  pname = "phosh";
  version = "0.10.2";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "07i8wpzl7311dcf9s57s96qh1v672c75wv6cllrxx7fsmpf8fhx4";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    phoc
    libhandy
    libsecret
    libxkbcommon
    pulseaudio
    glib
    gcr
    networkmanager
    polkit
    gnome3.gnome-control-center
    gnome3.gnome-desktop
    gnome3.gnome-session
    gtk3
    pam
    systemd
    upower
    wayland
    feedbackd
  ];

  checkInputs = [
    dbus
    xvfb_run
  ];

  # Temporarily disabled - Test is broken (SIGABRT)
  doCheck = false;

  postUnpack = ''
    rmdir $sourceRoot/subprojects/gvc
    ln -s ${gvc} $sourceRoot/subprojects/gvc
  '';

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
  '';

  checkPhase = ''
    runHook preCheck
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
    runHook postCheck
  '';

  # Replace the launcher script with ours
  postInstall = ''
    substituteAll ${executable} $out/bin/phosh
  '';

  # Depends on GSettings schemas in gnome-shell
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome3.gnome-shell}/share/gsettings-schemas/${gnome3.gnome-shell.name}"
    )
  '';

  postFixup = ''
    mkdir -p $out/share/wayland-sessions
    ln -s $out/share/applications/sm.puri.Phosh.desktop $out/share/wayland-sessions/
    # The OSK0.desktop points to a dummy stub that's not needed
    rm $out/share/applications/sm.puri.OSK0.desktop
  '';

  passthru = {
    providedSessions = [
     "sm.puri.Phosh"
    ];
  };

  meta = with lib; {
    description = "A pure Wayland shell prototype for GNOME on mobile devices";
    homepage = "https://source.puri.sm/Librem5/phosh";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ archseer jtojnar masipcat zhaofengli ];
    platforms = platforms.linux;
  };
}
