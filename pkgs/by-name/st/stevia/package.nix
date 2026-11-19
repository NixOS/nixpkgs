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
  uim,
  glib,
  gmobile,
  gst_all_1,
  gnome-desktop,
  libsoup_3,
  gtk3,
  hunspell,
  json-glib,
  libhandy,
  libxkbcommon,
  systemdLibs,
  nix-update-script,
  dconf,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "stevia";
  version = "0.59.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/Phosh";
    repo = "stevia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/yaXYxAQvpaoJqoMI2kP0VnonUpogz4D+eQ7jWAa3gQ=";
    # Workaround for https://github.com/NixOS/nixpkgs/issues/485701
    forceFetchGit = true;
  };

  mesonFlags = [
    "-Dgovarnam=disabled" # Isn't packaged as of now
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
    gst_all_1.gstreamer
    gst_all_1.gst-devtools
    gnome-desktop
    gtk3
    hunspell
    libsoup_3
    hunspell
    uim
    json-glib
    libhandy
    libxkbcommon
    systemdLibs
    dconf
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "User friendly on screen keyboard for Phosh";
    homepage = "https://gitlab.gnome.org/World/Phosh/stevia";
    changelog = "https://gitlab.gnome.org/World/Phosh/stevia/-/releases/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ungeskriptet
      armelclo
    ];
    mainProgram = "phosh-osk-stevia";
  };
})
