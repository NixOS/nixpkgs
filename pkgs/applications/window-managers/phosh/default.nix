{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
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
}:

stdenv.mkDerivation rec {
  pname = "phosh";
  version = "0.17.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true; # including gvc and libcall-ui which are designated as subprojects
    sha256 = "sha256-o/0NJZo1EPpXguN/tkUc+/9XaVTQWaLGe+2pU0B91Cg=";
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

  mesonFlags = [ "-Dsystemd=true" "-Dcompositor=${phoc}/bin/phoc" ];

  patches = [
    # build: Adjust to polkit version changes
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/Phosh/phosh/-/commit/16b46e295b86cbf1beaccf8218cf65ebb4b7a6f1.patch";
      sha256 = "sha256-Db1OEdiI1QBHGEBs1Coi7LTF9bCScdDgxmovpBdIY/g=";
    })
    # polkit-auth-agent: Scope cleanup function for PolkitAgentListener
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/Phosh/phosh/-/commit/b864653df50bfd8f34766fc6b37a3bf32cfbdfa4.patch";
      sha256 = "sha256-YCw3tGk94NAa6PPTmA1lCJVzzi9GC74BmvtTcvuHPh0=";
    })
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
    maintainers = with maintainers; [ jtojnar masipcat zhaofengli ];
    platforms = platforms.linux;
  };
}
