{
  lib,
  flutter347,
  fetchFromGitHub,
  nix-update-script,
}:

flutter347.buildFlutterApplication (finalAttrs: {
  pname = "recon";
  version = "0.12.2-beta";

  src = fetchFromGitHub {
    owner = "Nutcake";
    repo = "Recon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y1dW8Llf3/5d5Tx6x0NCERowsSlsIntchWhCGvtfw6Y=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Contacts app for Resonite, built with flutter";
    homepage = "https://github.com/Nutcake/Recon";
    mainProgram = "recon";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bddvlpr ];
  };
})
