{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  glib,
  rsync,
  openssh,
  rclone,
}:

rustPlatform.buildRustPackage rec {
  pname = "moraine";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "TheJonaz";
    repo = "moraine-backup";
    tag = "v${version}";
    hash = "sha256-0IrD43U7N0mAVr/YPP2NIMPWDxJGLCpeZG16X3kVARU=";
  };

  cargoHash = "sha256-06puLUEUckzKFPdySP1A1E739VwK1FKDpxrsHB+a8O4=";

  __structuredAttrs = true;

  buildFeatures = [ "gui" ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    gtk4
    glib
  ];

  # Requires moraine >= 0.1.19: assets are resolved via XDG_DATA_DIRS, which
  # wrapGAppsHook4 points at $out/share.
  postInstall = ''
    install -Dm644 assets/moraine-gui.desktop \
      $out/share/applications/io.thern.moraine.desktop
    install -Dm644 assets/moraine.svg \
      $out/share/icons/hicolor/scalable/apps/moraine.svg
    install -Dm644 assets/moraine-256.png \
      $out/share/icons/hicolor/256x256/apps/moraine.png
    for a in hero-bg.png moraine-64.png moraine-256.png; do
      install -Dm644 "assets/$a" "$out/share/moraine/assets/$a"
    done
  '';

  # rsync / ssh / rclone on the runtime PATH (wrapGAppsHook4 applies these when
  # it wraps both binaries — no separate wrapProgram, so no double-wrapping).
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      rsync
      openssh
      rclone
    ])
  ];

  meta = {
    description = "Snapshot-based backup over SSH/rsync and rclone (CLI + GTK app)";
    homepage = "https://moraine.thern.io";
    changelog = "https://github.com/TheJonaz/moraine-backup/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "moraine";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thejonaz ];
  };
}
