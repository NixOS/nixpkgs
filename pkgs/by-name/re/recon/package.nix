{
  lib,
  flutter347,
  fetchFromGitHub,
  copyDesktopItems,
  nix-update-script,
  makeDesktopItem,
}:

flutter347.buildFlutterApplication (finalAttrs: {
  pname = "recon";
  version = "0.13.1-beta";

  src = fetchFromGitHub {
    owner = "Nutcake";
    repo = "Recon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6bNqfdAYfiWEsbS5cIOui4Xacl/qcXv9BAfA7smcins=";
  };

  autoPubspecLock = finalAttrs.src + "/pubspec.lock";

  nativeBuildInputs = [ copyDesktopItems ];

  passthru.updateScript = nix-update-script { };

  postInstall = ''
    install -Dm644 assets/images/logo512.png "$out/share/icons/hicolor/512x512/apps/recon.png"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "recon";
      icon = "recon";
      exec = "recon %u";
      terminal = false;
      desktopName = "Recon";
      comment = "Contacts app for Resonite, built with flutter";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Contacts app for Resonite, built with flutter";
    homepage = "https://github.com/Nutcake/Recon";
    mainProgram = "recon";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bddvlpr ];
  };
})
