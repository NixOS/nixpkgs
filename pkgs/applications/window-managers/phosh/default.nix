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
, gnome-desktop
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
, evolution-data-server
}:

stdenv.mkDerivation rec {
  pname = "phosh";
  version = "0.21.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true; # including gvc and libcall-ui which are designated as subprojects
    sha256 = "sha256-I0BWwEKvOYQ1s2IpvV70GWxhARdX6AZ+B4ypnTlLlDw=";
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
    evolution-data-server
    pulseaudio
    glib
    gcr
    networkmanager
    polkit
    gnome.gnome-control-center
    gnome-desktop
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

  mesonFlags = [
    "-Dsystemd=true"
    "-Dcompositor=${phoc}/bin/phoc"
    # https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

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
    maintainers = with maintainers; [ masipcat zhaofengli ];
    platforms = platforms.linux;
  };
}
