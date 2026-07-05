{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "17.15.3";
  source =
    {
      x86_64-linux = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-x86_64.tar.xz";
        hash = "sha256-cZKRmpJKv5I8Bjdi44vkRT424Lx8X71E8suHMJRKMVg=";
      };
      aarch64-linux = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-arm64.tar.xz";
        hash = "sha256-av/exxhssyZgvLvlJsvxqTOymRLNu5eXl8zTv1rsLN0=";
      };
      x86_64-darwin = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-macos-x86_64.tar.xz";
        hash = "sha256-slmk8Zbk329pMscVWPXOi9G793wXquFuVBWLH2yuiYE=";
      };
      aarch64-darwin = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-macos-arm64.tar.xz";
        hash = "sha256-X65oBfz/yC92CHVIOg5ZAZwlAMgUQ/6MpBfi5uBLirg=";
      };
    }
    .${system} or (throw "Unsupported system: ${system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libfrida-core";
  inherit version;

  src = fetchurl {
    inherit (source) url hash;
  };
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include $out/lib
    tar -xf $src -C .
    install -Dm755 libfrida-core.a -t $out/lib
    install -Dm644 frida-core.h -t $out/include
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Frida core library intended for static linking into bindings";
    homepage = "https://frida.re/";
    changelog = "https://frida.re/news/";
    license = lib.licenses.wxWindowsException31;
    maintainers = with lib.maintainers; [ nilathedragon ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
