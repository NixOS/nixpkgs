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
, gnome
, gcr
, pam
, systemd
, upower
, wayland
, dbus
, xvfb-run
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
in stdenv.mkDerivation rec {
  pname = "phosh";
  version = "0.12.0";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s0lgq04qz562iri535wpwvfkmmngdpclyl329cf7rc9ihy1kjvs";
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
    gnome.gnome-control-center
    gnome.gnome-desktop
    gnome.gnome-session
    gtk3
    pam
    systemd
    upower
    wayland
    feedbackd
  ];

  checkInputs = [
    dbus
    xvfb-run
  ];

  # Temporarily disabled - Test is broken (SIGABRT)
  doCheck = false;

  mesonFlags = [ "-Dsystemd=true" "-Dcompositor=${phoc}/bin/phoc" ];

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

  # Depends on GSettings schemas in gnome-shell
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome.gnome-shell}/share/gsettings-schemas/${gnome.gnome-shell.name}"
      --set GNOME_SESSION "${gnome.gnome-session}/bin/gnome-session"
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
