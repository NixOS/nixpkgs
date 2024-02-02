{ lib
, stdenv
, fetchurl
, directoryListingUpdater
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
  version = "0.31.0";

  src = fetchurl {
    # This tarball includes the meson wrapped subproject 'gmobile'.
    url = "https://sources.phosh.mobi/releases/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-5Qa6LSOLvZL0sFh2co9AqyS5ZTQQ+JRnPiHuMl1UgDI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    phosh
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

  passthru.updateScript = directoryListingUpdater { };

  meta = with lib; {
    description = "A settings app for mobile specific things";
    homepage = "https://gitlab.gnome.org/guidog/phosh-mobile-settings";
    changelog = "https://gitlab.gnome.org/guidog/phosh-mobile-settings/-/blob/v${version}/debian/changelog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
  };
}
