{ lib
, stdenv
, fetchFromGitHub
, testers
, wrapGAppsHook
, bash-completion
, dbus
, dbus-glib
, fish
, gdk-pixbuf
, glib
, gobject-introspection
, gtk-layer-shell
, gtk3
, json-glib
, libhandy
, librsvg
, meson
, ninja
, pkg-config
, python3
, scdoc
, vala
, xvfb-run
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "SwayNotificationCenter";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayNotificationCenter";
    rev = "v${version}";
    hash = "sha256-Z8CFSaH4RsZ/Qgj+l+36p7smbiGV5RRQhZBBcA3iyK8=";
  };

  nativeBuildInputs = [
    bash-completion
    # cmake # currently conflicts with meson
    fish
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    scdoc
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    dbus
    dbus-glib
    gdk-pixbuf
    glib
    gtk-layer-shell
    gtk3
    json-glib
    libhandy
    librsvg
    # systemd # ends with broken permission
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "${xvfb-run}/bin/xvfb-run swaync --version";
  };

  meta = with lib; {
    description = "Simple notification daemon with a GUI built for Sway";
    homepage = "https://github.com/ErikReider/SwayNotificationCenter";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche pedrohlc ];
  };
})
