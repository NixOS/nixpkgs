{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "17.9.11";
  source =
    {
      x86_64-linux = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-x86_64.tar.xz";
        hash = "sha256-xMrVB7TDb+Op3nfnXCr7f6AoMg07fVDSgU8eXsAKIf0=";
      };
      aarch64-linux = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-arm64.tar.xz";
        hash = "sha256-8Crtn/amFtdenbkFYfyeK/zDyPiuekgog9KJBFKX01I=";
      };
      x86_64-darwin = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-macos-x86_64.tar.xz";
        hash = "sha256-2LtXQyP/wew0K20KoQoLNkslrvXJl8vipNQR9lghCVU=";
      };
      aarch64-darwin = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-macos-arm64.tar.xz";
        hash = "sha256-6sezmw6qZ5Mqe+QlGH8ynwFQ49nKvPZigZ/RJAC1z1M=";
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
