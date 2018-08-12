{ stdenv
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
, wlroots
, dbus
, xvfb_run
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
  version = "unstable-2019-03-23";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "cdcb8732ae519a504dd1e562e5c3d80dce4c258a";
    sha256 = "0zjily3gn8raz3r2g1s41d9vjprjk7jg1vravi729vha8bcxc686";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      rootston = "${wlroots.bin}/bin/rootston";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    libhandy
    pulseaudio
    glib
    gcr
    gnome3.gnome-desktop
    gtk3
    pam
    upower
    wayland
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
    mkdir -p $out/share/wayland-sessions
    ln -s $out/share/applications/sm.puri.Phosh.desktop $out/share/wayland-sessions
  '';

  meta = with stdenv.lib; {
    description = "A pure Wayland shell prototype for GNOME on mobile devices";
    homepage = https://source.puri.sm/Librem5/phosh;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
