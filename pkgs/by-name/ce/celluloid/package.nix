{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  desktop-file-utils,
  glib,
  gtk4,
  libGL,
  libepoxy,
  libadwaita,
  meson,
  mpv,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "celluloid";
  version = "0.26";

  src = fetchFromGitHub {
    owner = "celluloid-player";
    repo = "celluloid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-npaagLlkwDe0r0hqj7buM4B9sbLCX1sR2yFXXj+obdE=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libGL
    libadwaita
    libepoxy
    mpv
  ];

  postPatch = ''
    patchShebangs meson-post-install.py src/generate-authors.py
  '';

  strictDeps = true;

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/celluloid-player/celluloid";
    description = "Simple GTK frontend for the mpv video player";
    longDescription = ''
      Celluloid (formerly GNOME MPV) is a simple GTK+ frontend for mpv.
      Celluloid interacts with mpv via the client API exported by libmpv,
      allowing access to mpv's powerful playback capabilities.
    '';
    changelog = "https://github.com/celluloid-player/celluloid/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "celluloid";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
