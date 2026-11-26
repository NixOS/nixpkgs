{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  sqlite,
  zstd,
  desktop-file-utils,
  appstream,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lanner";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Konakonai";
    repo = "lanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nqAGLgjk2A6ax4j9Tie9dJPaKl+jPaR7HD7ApZBwtzE=";
  };

  cargoHash = "sha256-Mdm/fzJt9J1QCmpx8TOnsWYf2yZnL0WNN41ZjcYak8Y=";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    sqlite
    zstd
  ];

  postInstall = ''
    install -Dm644 data/io.github.konakonai.Lanner.desktop -t $out/share/applications
    install -Dm644 data/io.github.konakonai.Lanner.metainfo.xml -t $out/share/metainfo
    install -Dm644 data/io.github.konakonai.Lanner.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    desktop-file-utils
    appstream
    versionCheckHook
  ];
  installCheckPhase = ''
    runHook preInstallCheck
    desktop-file-validate $out/share/applications/io.github.konakonai.Lanner.desktop
    appstreamcli validate --no-net $out/share/metainfo/io.github.konakonai.Lanner.metainfo.xml
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Usage, cost and speed of AI coding agents";
    homepage = "https://github.com/Konakonai/lanner";
    changelog = "https://github.com/Konakonai/lanner/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ konakonai ];
    mainProgram = "lanner";
    platforms = lib.platforms.linux;
  };
})
