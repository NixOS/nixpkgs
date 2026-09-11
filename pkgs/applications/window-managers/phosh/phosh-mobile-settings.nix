{
  lib,
  stdenv,
  fetchFromGitLab,
  nixosTests,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wrapGAppsHook4,
  desktop-file-utils,
  feedbackd,
  gtk4,
  libadwaita,
  lm_sensors,
  phoc,
  phosh,
  wayland-protocols,
  json-glib,
  gsound,
  gmobile,
  gnome-desktop,
  libpulseaudio,
  libportal,
  libportal-gtk4,
  glib,
  libyaml,
  mobile-broadband-provider-info,
  modemmanager,
  gobject-introspection,
  appstream,
  gst_all_1,
}:

let
  # Derived from subprojects/gvc.wrap
  gvc = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "guidog";
    repo = "libgnome-volume-control";
    rev = "d2442f455844e5292cb4a74ffc66ecc8d7595a9f";
    hash = "sha256-10n441b7m/mvQRdrmEsxGxqjKUWzjGvnzJy256NZN5s=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };
  # Derived from subprojects/glibcellbroadcast.wrap
  libcellbroadcast = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "devrtz";
    repo = "cellbroadcastd";
    tag = "v0.0.2";
    hash = "sha256-rs9MoC54sVrs3HK0cbX4msYWA63y+DlDOZ5LboVtW9Y=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };
  # Derived from subprojects/libcellbroadcast/subprojects/gvdb.wrap
  gvdb = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gvdb";
    rev = "4758f6fb7f889e074e13df3f914328f3eecb1fd3";
    hash = "sha256-4mqoHPlrMPenoGPwDqbtv4/rJ/uq9Skcm82pRvOxNIk=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };
in
stdenv.mkDerivation rec {
  pname = "phosh-mobile-settings";
  version = "0.54.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "phosh-mobile-settings";
    rev = "v${version}";
    hash = "sha256-TuwxzzalNhNJwPmmPJmxsHebzksPYv8jV6K0vYntQIw=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    phosh
    pkg-config
    wayland-scanner
    wrapGAppsHook4
    glib.dev
    gobject-introspection
    appstream
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
    gmobile
    gnome-desktop
    libpulseaudio
    libportal
    libportal-gtk4
    libyaml
    mobile-broadband-provider-info
    modemmanager
    gst_all_1.gst-plugins-base
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
