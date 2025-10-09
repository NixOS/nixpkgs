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
}:

let
  # Derived from subprojects/gvc.wrap
  gvc = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgnome-volume-control";
    rev = "5f9768a2eac29c1ed56f1fbb449a77a3523683b6";
    hash = "sha256-gdgTnxzH8BeYQAsvv++Yq/8wHi7ISk2LTBfU8hk12NM=";
  };
  # Derived from subprojects/glibcellbroadcast.wrap
  libcellbroadcast = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "devrtz";
    repo = "cellbroadcastd";
    tag = "v0.0.2";
    hash = "sha256-rs9MoC54sVrs3HK0cbX4msYWA63y+DlDOZ5LboVtW9Y=";
  };
  # Derived from subprojects/libcellbroadcast/subprojects/gvdb.wrap
  gvdb = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gvdb";
    rev = "4758f6fb7f889e074e13df3f914328f3eecb1fd3";
    hash = "sha256-4mqoHPlrMPenoGPwDqbtv4/rJ/uq9Skcm82pRvOxNIk=";
  };
in
stdenv.mkDerivation rec {
  pname = "phosh-mobile-settings";
  version = "0.50.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "phosh-mobile-settings";
    rev = "v${version}";
    hash = "sha256-hcq99ilfclZCviFhpQ9mQLcpf7wc+IvlUOb0duQM6fk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    phosh
    pkg-config
    wayland-scanner
    wrapGAppsHook4
    glib.dev
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
