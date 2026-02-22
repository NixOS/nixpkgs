{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  python3,
  wayland-scanner,
  wrapGAppsHook3,
  appstream,
  cmake,
  feedbackd,
  fzf,
  glib,
  gmobile,
  gnome-desktop,
  gtk3,
  hunspell,
  json-glib,
  libhandy,
  libxkbcommon,
  systemd,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "stevia";
  version = "0.52.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/Phosh";
    repo = "stevia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GdAKy7F8SRGtfmN6as6AAg6p/WJrcDPp338OHUXoORM=";
  };

  mesonFlags = [
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
  ];

  postPatch = ''
    patchShebangs --build tools/write-layout-info.py
  '';

  nativeBuildInputs = [
    meson
    cmake
    ninja
    pkg-config
    python3
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    appstream
    feedbackd
    fzf
    glib.dev
    gmobile
    gnome-desktop
    gtk3
    hunspell
    json-glib
    libhandy
    libxkbcommon
    systemd
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "User friendly on screen keyboard for Phosh";
    homepage = "https://gitlab.gnome.org/World/Phosh/stevia";
    changelog = "https://gitlab.gnome.org/World/Phosh/stevia/-/releases/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ungeskriptet
      armelclo
    ];
    mainProgram = "phosh-osk-stevia";
  };
})
