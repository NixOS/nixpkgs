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
, libgudev
, callaudiod
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
}:

stdenv.mkDerivation rec {
  pname = "phosh";
  version = "0.15.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true; # including gvc and libcall-ui which are designated as subprojects
    sha256 = "sha256-ZEfYjgSaj4vVdfgdIcg0PWwlFX90PIm5wvdn9P/8tvo=";
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
    libgudev
    callaudiod
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
    homepage = "https://gitlab.gnome.org/World/Phosh/phosh";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar masipcat zhaofengli ];
    platforms = platforms.linux;
  };
}
