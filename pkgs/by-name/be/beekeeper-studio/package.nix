{
  stdenv,
  callPackage,
  lib,
  ...
}:
let
  pname = "beekeeper-studio";
  version = "5.2.12";
  meta = {
    description = "Modern and easy to use SQL client for MySQL, Postgres, SQLite, SQL Server, and more";
    homepage = "https://www.beekeeperstudio.io";
    changelog = "https://github.com/beekeeper-studio/beekeeper-studio/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "beekeeper-studio";
    maintainers = with lib.maintainers; [
      milogert
      alexnortung
      iamanaws
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    knownVulnerabilities = [ "Electron version 31 is EOL" ];
  };
  passthru.updateScript = ./update.sh;
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      meta
      passthru
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      meta
      passthru
      ;
  }
