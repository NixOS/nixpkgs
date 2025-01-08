{
  lib,
  stdenv,
  fetchFromGitLab,
  nixosTests,
  directoryListingUpdater,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wrapGAppsHook4,
  desktop-file-utils,
  feedbackd,
  gnome-desktop,
  gtk4,
  libadwaita,
  lm_sensors,
  phoc,
  phosh,
  wayland-protocols,
  json-glib,
  gsound,
  gmobile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phosh-mobile-settings";
  version = "0.44.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "phosh-mobile-settings";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ysQ0lwCS1bQLRQg2aoauyAYnhAqM5B7c3neKJvqcsjw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    phosh
    pkg-config
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    desktop-file-utils
    feedbackd
    gnome-desktop
    gtk4
    libadwaita
    lm_sensors
    phoc
    wayland-protocols
    json-glib
    gsound
    gmobile
  ];

  postInstall = ''
    # this is optional, but without it phosh-mobile-settings won't know about lock screen plugins
    ln -s '${phosh}/lib/phosh' "$out/lib/phosh"
  '';

  passthru = {
    tests.phosh = nixosTests.phosh;
    updateScript = directoryListingUpdater { };
  };

  meta = {
    description = "Settings app for mobile specific things";
    mainProgram = "phosh-mobile-settings";
    homepage = "https://gitlab.gnome.org/World/Phosh/phosh-mobile-settings";
    changelog = "https://gitlab.gnome.org/World/Phosh/phosh-mobile-settings/-/blob/v${finalAttrs.version}/debian/changelog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rvl ];
    platforms = lib.platforms.linux;
  };
})
