{
  accountsservice,
  appstream,
  cmake,
  desktop-file-utils,
  feedbackd,
  fetchFromGitLab,
  glib,
  gmobile,
  gnome-desktop,
  gobject-introspection,
  gsound,
  gst_all_1,
  gtk4,
  json-glib,
  lib,
  libadwaita,
  libportal,
  libportal-gtk4,
  libpulseaudio,
  libyaml,
  lm_sensors,
  meson,
  mobile-broadband-provider-info,
  modemmanager,
  networkmanager,
  ninja,
  nix-update-script,
  nixosTests,
  phoc,
  phosh,
  pkg-config,
  polkit,
  stdenv,
  wayland-protocols,
  wayland-scanner,
  wrapGAppsHook4,
}:

let
  # Derived from subprojects/gvc.wrap
  gvc = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "guidog";
    repo = "libgnome-volume-control";
    rev = "d2442f455844e5292cb4a74ffc66ecc8d7595a9f";
    hash = "sha256-4s9S6m/rcroR38FSnLeWKZhnym4KROfibgRCjpGMKpY=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };
  # Derived from subprojects/glibcellbroadcast.wrap
  libcellbroadcast = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "devrtz";
    repo = "cellbroadcastd";
    tag = "v0.0.3";
    hash = "sha256-QMx/E631aWJIwvRDbzyrO9K+7xdd54ZbiE4Eoune3Co=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };
  # Derived from subprojects/libcellbroadcast/subprojects/gvdb.wrap
  gvdb = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gvdb";
    rev = "c6f2359cc1d00f16e0a0e2527fa0bc1882b8b5ab";
    hash = "sha256-FQPctq+fj6du0sBawaJxtO0PRO0KIHHhdA2jh24Yacw=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };
in
stdenv.mkDerivation rec {
  pname = "phosh-mobile-settings";
  version = "0.58.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "phosh-mobile-settings";
    rev = "v${version}";
    hash = "sha256-ceFgZKLTecuBybWhW3/Z22msvz2gw/rMop3QtDucG9o=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };

  nativeBuildInputs = [
    appstream
    glib.dev
    gobject-introspection
    meson
    ninja
    phosh
    pkg-config
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    cmake
    desktop-file-utils
    feedbackd
    gmobile
    gnome-desktop
    gsound
    gst_all_1.gst-plugins-base
    gtk4
    json-glib
    libadwaita
    libportal
    libportal-gtk4
    libpulseaudio
    libyaml
    lm_sensors
    mobile-broadband-provider-info
    modemmanager
    networkmanager
    phoc
    polkit
    wayland-protocols
  ];

  postPatch = ''
    ln -s ${gvc} subprojects/gvc
    ln -s ${libcellbroadcast} subprojects/libcellbroadcast
    ln -s ${gvdb} subprojects/gvdb
  '';

  postInstall = ''
    # this is optional, but without it phosh-mobile-settings won't know about lock screen plugins
    ln -s '${phosh}/lib/phosh' "$out/lib/phosh"
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  passthru = {
    tests.phosh = nixosTests.phosh;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Settings app for mobile specific things";
    mainProgram = "phosh-mobile-settings";
    homepage = "https://gitlab.gnome.org/World/Phosh/phosh-mobile-settings";
    changelog = "https://gitlab.gnome.org/World/Phosh/phosh-mobile-settings/-/blob/v${version}/debian/changelog";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      rvl
      armelclo
    ];
    platforms = lib.platforms.linux;
  };
}
