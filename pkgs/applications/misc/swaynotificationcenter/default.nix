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
, scdoc
, vala
, xvfb-run
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "SwayNotificationCenter";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayNotificationCenter";
    rev = "v${version}";
    hash = "sha256-79Kda2Mi2r38f0J12bRm9wbHiZCy9+ojPDxwlFG8EYw=";
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

  # Fix-Me: Broken in 0.6.3, but fixed on master. Enable on next release. Requires python3 in nativeBuildInputs.
  # postPatch = ''
  #   chmod +x build-aux/meson/postinstall.py
  #   patchShebangs build-aux/meson/postinstall.py
  # '';

  # Remove past 0.6.3
  postInstall = ''
    glib-compile-schemas "$out"/share/glib-2.0/schemas
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
