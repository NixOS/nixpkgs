{
  fetchFromGitHub,
  lib,
  stdenv,
  rustPlatform,
  gtk4,
  pkg-config,
  pango,
  wrapGAppsHook4,
  versionCheckHook,
  copyDesktopItems,
  makeDesktopItem,
  desktopToDarwinBundle,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "packetry";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "packetry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mgQmorh/MSSufVyOspVtZhBn4nS1vITAiiDXv+/dc/o=";
  };

  cargoHash = "sha256-qku45EAnsZetQ3Q0Y5Pr1OL/St0j6DGIjnlohA8+pDs=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    copyDesktopItems
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    gtk4
    pango
  ];

  # Disable test_replay tests as they need a gui
  preCheck = ''
    substituteInPlace src/ui/test_replay.rs \
      --replace-fail '#[test]' '#[test] #[ignore]'
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  desktopItems = [
    (makeDesktopItem {
      name = "packetry";
      desktopName = "Packetry";
      comment = finalAttrs.meta.description;
      exec = "packetry";
      icon = "packetry";
      categories = [ "Utility" ];
    })
  ];

  # packetry-cli is only necessary on windows https://github.com/greatscottgadgets/packetry/pull/154
  postInstall = ''
    rm $out/bin/packetry-cli

    install -Dm644 appimage/dist/icon.png \
      $out/share/icons/hicolor/512x512/apps/packetry.png
  '';

  meta = {
    description = "USB 2.0 protocol analysis application for use with Cynthion";
    homepage = "https://github.com/greatscottgadgets/packetry";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
    mainProgram = "packetry";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
