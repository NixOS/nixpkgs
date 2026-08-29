{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  glib,
  cairo,
  pango,
  git,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitpulsar";
  version = "1.3.1";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "ilshat-apps";
    repo = "gitpulsar";
    tag = "v${version}";
    hash = "sha256-TjfCZ7u8OgPJcgwoizfEcojYD1RJXyLejHVvlkTHseE=";
  };

  cargoHash = "sha256-/+Ol4dsTEBgAUmGyE0rmkI56zjL6giSwoZ1VWFnDKrM=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    cairo
    pango
    openssl
  ];

  doCheck = false;

  postInstall = ''
    install -Dm644 data/io.gitlab.ilshat_apps.gitpulsar.desktop $out/share/applications/io.gitlab.ilshat_apps.gitpulsar.desktop
    install -Dm644 data/io.gitlab.ilshat_apps.gitpulsar.metainfo.xml $out/share/metainfo/io.gitlab.ilshat_apps.gitpulsar.metainfo.xml
    install -Dm644 data/icons/hicolor/scalable/apps/io.gitlab.ilshat_apps.gitpulsar.svg $out/share/icons/hicolor/scalable/apps/io.gitlab.ilshat_apps.gitpulsar.svg

    for icon in data/icons/hicolor/scalable/actions/*.svg; do
      install -Dm644 "$icon" "$out/share/icons/hicolor/scalable/actions/$(basename "$icon")"
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ git ]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, native Git client for GNOME";
    homepage = "https://gitlab.com/ilshat-apps/gitpulsar";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rachalaraj ];
    mainProgram = "gitpulsar-gtk";
  };
}
