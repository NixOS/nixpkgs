{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  makeDesktopItem,
  copyDesktopItems,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxker";
  version = "0.13.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-9kJ+oUwv3hAYANJ8RtVc1P3f15ImfeqXur1h8DT90Vg=";
  };

  cargoHash = "sha256-Tv1+M3Xupdj7ZHsLw5eObGbw1gmVhDDDd3faY4O6mqM=";

  # See https://github.com/mrjackwills/oxker/issues/73
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=ui::draw_blocks::help::tests::test_draw_blocks_help_custom_keymap_one_definition"
    "--skip=ui::draw_blocks::help::tests::test_draw_blocks_help_custom_keymap_two_definitions"
    "--skip=ui::draw_blocks::help::tests::test_draw_blocks_help_one_and_two_definitions"
  ];

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "oxker";
      comment = finalAttrs.meta.description;
      exec = finalAttrs.meta.mainProgram;
      icon = "oxker";
      terminal = true;
      categories = [
        "System"
        "Utility"
        "Monitor"
        "ConsoleOnly"
      ];
      keywords = [
        "docker"
        "container"
      ];
    })
  ];

  postInstall = ''
    mkdir --parents $out/share/icons/hicolor/scalable/apps
    cp .github/logo.svg $out/share/icons/hicolor/scalable/apps/oxker.svg
  '';

  meta = {
    description = "Simple TUI to view & control docker containers";
    homepage = "https://github.com/mrjackwills/oxker";
    changelog = "https://github.com/mrjackwills/oxker/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siph ];
    mainProgram = "oxker";
  };
})
