{
  lib,
  stdenv,
  callPackage,
}:
let
  version = "5.5.243";
  pname = "gdevelop";
  meta = {
    description = "Graphical Game Development Studio";
    homepage = "https://gdevelop.io/";
    downloadPage = "https://github.com/4ian/GDevelop/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      tombert
      matteopacini
    ];
    mainProgram = "gdevelop";
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
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
