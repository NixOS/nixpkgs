{
  lib,
  stdenv,
  callPackage,
  ...
}:
let
  pname = "lmstudio";
  version = "0.2.24";
  meta = {
    description = "LM Studio is an easy to use desktop app for experimenting with local and open-source Large Language Models (LLMs)";
    homepage = "https://lmstudio.ai/";
    license = lib.licenses.unfree;
    mainProgram = "lmstudio";
    maintainers = with lib.maintainers; [
      cig0
      eeedean
    ];
    platforms = lib.platforms.linux ++ [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
if stdenv.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix { inherit pname version meta; }
