{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, wrapGAppsHook
, desktop-file-utils
, feedbackd
, gtk4
, libadwaita
, lm_sensors
, phoc
, phosh
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "phosh-mobile-settings";
  version = "0.21.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "guidog";
    repo = "phosh-mobile-settings";
    rev = "v${version}";
    sha256 = "sha256-60AXaKSF8bY+Z3TNlIIa7jZwQ2IkHqCbZ3uIlhkx6i0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    desktop-file-utils
    feedbackd
    gtk4
    libadwaita
    lm_sensors
    phoc
    phosh
    wayland-protocols
  ];

  postInstall = ''
    # this is optional, but without it phosh-mobile-settings won't know about lock screen plugins
    ln -s '${phosh}/lib/phosh' "$out/lib/phosh"

    # .desktop files marked `OnlyShowIn=Phosh;` aren't displayed even in our phosh, so remove that.
    # also make the Exec path absolute.
    substituteInPlace "$out/share/applications/org.sigxcpu.MobileSettings.desktop" \
      --replace 'OnlyShowIn=Phosh;' "" \
      --replace 'Exec=phosh-mobile-settings' "Exec=$out/bin/phosh-mobile-settings"
  '';

  meta = with lib; {
    description = "A settings app for mobile specific things";
    homepage = "https://gitlab.gnome.org/guidog/phosh-mobile-settings";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
  };
}
