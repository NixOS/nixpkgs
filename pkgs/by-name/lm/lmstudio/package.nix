{
  lib,
  stdenv,
  callPackage,
  ...
}@args:
let
  pname = "lmstudio";

  version_aarch64-linux = "0.4.5-2";
  hash_aarch64-linux = "sha256-BeF9FNMde9RW2icdq07zkWQafge7ViWKvR+xupRIdjE=";
  version_aarch64-darwin = "0.4.6-1";
  hash_aarch64-darwin = "sha256-CpeBUXpBAOJPEZAb3neY5pWRSGNcy4Usgsm6qyI5PVA=";
  version_x86_64-linux = "0.4.6-1";
  hash_x86_64-linux = "sha256-FHZ64zmnqHrQyX4ift/lVUzW+HiCVkXpWVa4hkssX/k=";

  meta = {
    description = "LM Studio is an easy to use desktop app for experimenting with local and open-source Large Language Models (LLMs)";
    homepage = "https://lmstudio.ai/";
    license = lib.licenses.unfree;
    mainProgram = "lm-studio";
    maintainers = with lib.maintainers; [ crertel ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in
if stdenv.hostPlatform.system == "aarch64-darwin" then
  callPackage ./darwin.nix {
    inherit pname meta;
    passthru.updateScript = ./update.sh;
    version = version_aarch64-darwin;
    url =
      args.url
        or "https://installers.lmstudio.ai/darwin/arm64/${version_aarch64-darwin}/LM-Studio-${version_aarch64-darwin}-arm64.dmg";
    hash = args.hash or hash_aarch64-darwin;
  }
else if stdenv.hostPlatform.system == "aarch64-linux" then
  callPackage ./linux.nix {
    inherit pname meta;
    passthru.updateScript = ./update.sh;
    version = version_aarch64-linux;
    url =
      args.url
        or "https://installers.lmstudio.ai/linux/arm64/${version_aarch64-linux}/LM-Studio-${version_aarch64-linux}-arm64.AppImage";
    hash = args.hash or hash_aarch64-linux;
  }
else
  callPackage ./linux.nix {
    inherit pname meta;
    passthru.updateScript = ./update.sh;
    version = version_x86_64-linux;
    url =
      args.url
        or "https://installers.lmstudio.ai/linux/x64/${version_x86_64-linux}/LM-Studio-${version_x86_64-linux}-x64.AppImage";
    hash = args.hash or hash_x86_64-linux;
  }
