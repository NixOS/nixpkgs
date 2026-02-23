{
  callPackage,
  fetchurl,
  lib,
  stdenv,
  stdenvNoCC,
}:

let
  sources = import ./sources.nix { inherit fetchurl; };
  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  pname = "dingtalk";
  inherit (source) version src;
in
callPackage (if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname;
  inherit (source) version src;

  meta = {
    description = "Enterprise-level communication platform developed by Alibaba";
    homepage = "https://www.dingtalk.com";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      svecco
      prince213
    ];
    mainProgram = "dingtalk";
  };
}
