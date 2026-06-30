{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  rapidjson,
  buildPackages,
  makeDesktopItem,
  copyDesktopItems,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "circuit-artist";
  version = "1.0.5-unstable-2026-06-11";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lets-all-be-stupid-forever";
    repo = "circuit-artist";
    fetchSubmodules = true;
    rev = "ecdc65e6c4dc5289ed1a26a54c972bd046bbecb6";
    hash = "sha256-zRubQsOlhqpVYBkDk9pB/exVGy5if9g5YEjfY8yZhsM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config

    # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
    # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
    (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
    copyDesktopItems
  ];

  # required for the discord integration
  buildInputs = [
    rapidjson
  ];

  strictDeps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --run "export CA_ASSET_DIR=\''${CA_ASSET_DIR:-"$out/share/circuit-artist/assets"}"
      --run 'export CA_DATA_DIR=''${CA_DATA_DIR:-''${XDG_DATA_HOME:-~/.local/share}/circuit-artist}'
    )
  '';

  installPhase = ''
    runHook preInstall

    cd ..

    # binary
    install -Dm755 -T "./build/ca" "$out/bin/circuit-artist"

    # icons
    install -Dm444 -T "./assets/imgs/icon2.png" "$out/share/icons/hicolor/16x16/apps/circuit-artist.png"
    install -Dm444 -T "./assets/imgs/icon32.png" "$out/share/icons/hicolor/32x32/apps/circuit-artist.png"

    # assets
    mkdir -p "$out/share/circuit-artist"
    mv "./assets" "$out/share/circuit-artist"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "circuit-artist";
      icon = "circuit-artist";
      exec = "circuit-artist";
      desktopName = "Circuit Artist";
      genericName = "Circuit Simulator";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    mainProgram = "circuit-artist";
    description = "Digital circuit drawing and simulation game";
    homepage = "https://github.com/lets-all-be-stupid-forever/circuit-artist";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _0xAdk ];
  };
})
