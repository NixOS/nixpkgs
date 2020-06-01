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
, libsecret
, git
, writeText
, makeDesktopItem
}:

let
  gvc = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgnome-volume-control";
    rev = "e2be83ee4a47da9c4c4fbf302a63f04b8d5683b9";
    sha256 = "00sa48nzv15p2l4brh9ng06bzp1q8sw5v1srkz4s3kc4k42sl9vy";
  };

in stdenv.mkDerivation rec {
  pname = "phosh";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
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
    wrapGAppsHook
  ];

  buildInputs = [
    phoc
    libhandy
    libsecret
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
    runHook preCheck
    export NO_AT_BRIDGE=1
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
    runHook postCheck
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
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

  meta = with stdenv.lib; {
    description = "A pure Wayland shell prototype for GNOME on mobile devices";
    homepage = "https://source.puri.sm/Librem5/phosh";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
