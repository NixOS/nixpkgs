{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  # buildInputs
  mpv,
  libadwaita,
  libepoxy,
  openssl,

  # nativeBuildInputs
  makeBinaryWrapper,
  pkg-config,
  wrapGAppsHook4,
  glib,

  # Wrapper
  nodejs,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "losange";
  version = "0.10.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tymmesyde";
    repo = "losange";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mr54/vnaopLwG9lhFiZJGgxWH/VaGitROVEeV7GSyHM=";
  };

  cargoHash = "sha256-LJ8EpxEIN8wojSmQ+WVshYRxGFAC9sUk5tnh3I2J408=";

  buildInputs = [
    mpv
    libadwaita
    libepoxy
    openssl
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    wrapGAppsHook4
    glib
  ];

  postInstall = ''
    install -Dm444 data/xyz.timtimtim.Losange.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas/
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas/

    install -Dm444 data/icons/xyz.timtimtim.Losange.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 data/xyz.timtimtim.Losange.desktop -t $out/share/applications/
    install -Dm444 data/xyz.timtimtim.Losange.metainfo.xml -t $out/share/metainfo/

    # The application fails if '-o' is passed without an argument (e.g. when opened using a launcher)
    # therefore we match upstream's shell wrapper to handle empty URL cases.
    substituteInPlace $out/share/applications/xyz.timtimtim.Losange.desktop \
      --replace-fail "Exec=sh -c \"/usr/bin/losange -o '%u'\"" "Exec=sh -c \"losange -o '%u'\""
  '';

  # Node.js is required to run `server.js`
  # Losange will automatically download the required version of `server.js` at runtime.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ nodejs ]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "losange";
    description = "Simple Stremio client for GNOME";
    homepage = "https://github.com/tymmesyde/Losange";
    changelog = "https://github.com/tymmesyde/Losange/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ talal ];
  };
})
