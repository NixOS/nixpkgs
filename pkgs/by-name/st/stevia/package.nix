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
  version = "0.51.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/Phosh";
    repo = "stevia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dRygDUHXpXjEuwNNfgVy742jfIhT9erN7IcmaMImuYw=";
  };

  mesonFlags = [
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
  ];

  postPatch = ''
    patchShebangs tools/write-layout-info.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    appstream
    cmake
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
    description = "A user friendly on screen keyboard for Phosh";
    homepage = "https://gitlab.gnome.org/World/Phosh/stevia";
    changelog = "https://gitlab.gnome.org/World/Phosh/stevia/-/releases/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "stevia";
  };
})
