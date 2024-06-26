{ lib
, stdenv
, fetchurl
, nixosTests
, directoryListingUpdater
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, desktop-file-utils
, feedbackd
, gtk4
, libadwaita
, lm_sensors
, phoc
, phosh
, wayland-protocols
, json-glib
, gsound
}:

stdenv.mkDerivation rec {
  pname = "phosh-mobile-settings";
  version = "0.38.0";

  src = fetchurl {
    # This tarball includes the meson wrapped subproject 'gmobile'.
    url = "https://sources.phosh.mobi/releases/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-WDqgVsJx5y6IlWII9fRBsAeWn/tB8BaXRtlPvA0wmMk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    phosh
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    desktop-file-utils
    feedbackd
    gtk4
    libadwaita
    lm_sensors
    phoc
    wayland-protocols
    json-glib
    gsound
  ];

  postPatch = ''
    # There are no schemas to compile.
    substituteInPlace meson.build \
      --replace 'glib_compile_schemas: true' 'glib_compile_schemas: false'
  '';

  postInstall = ''
    # this is optional, but without it phosh-mobile-settings won't know about lock screen plugins
    ln -s '${phosh}/lib/phosh' "$out/lib/phosh"
  '';

  passthru = {
    tests.phosh = nixosTests.phosh;
    updateScript = directoryListingUpdater { };
  };

  meta = with lib; {
    description = "Settings app for mobile specific things";
    mainProgram = "phosh-mobile-settings";
    homepage = "https://gitlab.gnome.org/World/Phosh/phosh-mobile-settings";
    changelog = "https://gitlab.gnome.org/World/Phosh/phosh-mobile-settings/-/blob/v${version}/debian/changelog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rvl ];
    platforms = platforms.linux;
  };
}
