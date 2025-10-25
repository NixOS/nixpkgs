{
  lib,
  callPackage,
  stdenvNoCC,
  fetchurl,
  fetchzip,
}:
let
  inherit (stdenvNoCC.hostPlatform) isDarwin system;

  sources = import ./sources.nix { inherit fetchurl fetchzip; };
in
callPackage (if isDarwin then ./darwin.nix else ./linux.nix) {
  pname = "fastmail-desktop";
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Dedicated desktop app for Fastmail";
    homepage = "https://www.fastmail.com/blog/desktop-app/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [
      lib.maintainers.Enzime
      lib.maintainers.nekowinston
    ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
  };
}
