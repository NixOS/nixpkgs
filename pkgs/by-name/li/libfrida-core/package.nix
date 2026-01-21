{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "17.2.17";
  source =
    {
      x86_64-linux = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-x86_64.tar.xz";
        hash = "sha256-9elOokCY1bxzG2iL4iOODC/7qavwn77a0zOEBpAtT8Q=";
      };
      aarch64-linux = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-arm64.tar.xz";
        hash = "sha256-jk8BKmp3VNvCYK6kgGouFOBECoDaGiWQ8EzZvBwL7cc=";
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

  meta = {
    description = "Frida core library intended for static linking into bindings";
    homepage = "https://frida.re/";
    changelog = "https://frida.re/news/";
    license = lib.licenses.wxWindowsException31;
    maintainers = with lib.maintainers; [ nilathedragon ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
