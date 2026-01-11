{
  lib,
  flutter338,
  fetchFromGitHub,
  nix-update-script,
}:

flutter338.buildFlutterApplication rec {
  pname = "recon";
  version = "0.12.1-beta";

  src = fetchFromGitHub {
    owner = "Nutcake";
    repo = "Recon";
    tag = "v${version}";
    hash = "sha256-21fnYTjv4IWeR2kWzSIks1jZLpYJe3JAJbcMuKzCUSc=";
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
}
