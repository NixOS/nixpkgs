{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gtk4,
  libadwaita,
  libsoup_3,
  glib-networking,
  alsa-lib,
  pkg-config,
  wrapGAppsHook4,
  ffmpeg,
  glib,
  libpulseaudio,
  versionCheckHook,
  nix-update-script,
  pipewire,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "songrec";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = "songrec";
    tag = finalAttrs.version;
    hash = "sha256-6DT5KY6Y3CPTFLNG+EostAlMgZ35SLv8r9EXtRadC2U=";
  };

  cargoHash = "sha256-9R7HwTwjeCBIxX2xHs++9Zl0SMRmHPHDD1OHNa4q+jI=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    glib
    glib-networking
    gtk4
    libadwaita
    libpulseaudio
    libsoup_3
    pipewire
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"
    )
  '';

  postInstall = ''
    mv packaging/rootfs/usr/share $out/share
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source Shazam client for Linux, written in Rust";
    homepage = "https://github.com/marin-m/SongRec";
    changelog = "https://github.com/marin-m/SongRec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tomasrivera ];
    mainProgram = "songrec";
  };
})
