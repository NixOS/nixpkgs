{
  lib,
  stdenv,
  callPackage,
  ...
}@args:
let
  pname = "lmstudio-bionic";

  version_aarch64-darwin = "1.1.9-6";
  hash_aarch64-darwin = "sha256-hPpmtikwKj2hYUuDl7wtw0QIRXHUJspoWvSuNS7BPDg=";
  version_x86_64-linux = "1.1.9-6";
  hash_x86_64-linux = "sha256-I8/UNRlQXa0GQcYebbvI2uER85obNjO2wgSstvNiYZU=";
  version_aarch64-linux = "1.1.9-6";
  hash_aarch64-linux = "sha256-cgWnLvEWuuc7Ltb1zfO1zbAhWjTNP8Cw4ieJTzRiQbU=";

  meta = {
    description = "Bionic is an easy to use desktop app for experimenting with local and open-source Large Language Models (LLMs)";
    homepage = "https://lmstudio.ai/";
    license = lib.licenses.unfree;
    mainProgram = "bionic";
    maintainers = with lib.maintainers; [
      crertel
      deftdawg
    ];
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
        or "https://bionic-installers.lmstudio.ai/darwin/arm64/${version_aarch64-darwin}/Bionic-${version_aarch64-darwin}-arm64.dmg";
    hash = args.hash or hash_aarch64-darwin;
  }
else if stdenv.hostPlatform.system == "aarch64-linux" then
  callPackage ./linux.nix {
    inherit pname meta;
    passthru.updateScript = ./update.sh;
    version = version_aarch64-linux;
    url =
      args.url
        or "https://bionic-installers.lmstudio.ai/linux/arm64/${version_aarch64-linux}/Bionic-${version_aarch64-linux}-arm64.AppImage";
    hash = args.hash or hash_aarch64-linux;
  }
else
  callPackage ./linux.nix {
    inherit pname meta;
    passthru.updateScript = ./update.sh;
    version = version_x86_64-linux;
    url =
      args.url
        or "https://bionic-installers.lmstudio.ai/linux/x64/${version_x86_64-linux}/Bionic-${version_x86_64-linux}-x64.AppImage";
    hash = args.hash or hash_x86_64-linux;
  }
