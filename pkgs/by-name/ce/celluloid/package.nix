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
  mpv-unwrapped,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  wrapGAppsHook4,
  yt-dlp,
  youtubeSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "celluloid";
  version = "0.29";

  src = fetchFromGitHub {
    owner = "celluloid-player";
    repo = "celluloid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p4jMEM+ikcyVIi7cHm7u0wk9PKD8YJyhRXABgsh/SJc=";
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
    mpv-unwrapped
  ];

  postPatch = ''
    patchShebangs meson-post-install.py src/generate-authors.py
  '';

  preFixup = lib.optionalString youtubeSupport ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ yt-dlp ]}"
    )
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
    maintainers = with lib.maintainers; [ samlukeyes123 ];
    platforms = lib.platforms.linux;
  };
})
