{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "17.9.5";
  source =
    {
      x86_64-linux = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-x86_64.tar.xz";
        hash = "sha256-6YgD9srSHEGhtn6qSVljlVr6tu166VoY3EhashiLsCE=";
      };
      aarch64-linux = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-arm64.tar.xz";
        hash = "sha256-h4VPdfiz+a13mVIaL4YYTxhCsVJZh/u1t9fhGT95e7M=";
      };
      x86_64-darwin = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-macos-x86_64.tar.xz";
        hash = "sha256-y/IYH+qEtgiFgxdGZ1O9J01EYDOTGue2O3X7U5d8e8E=";
      };
      aarch64-darwin = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-macos-arm64.tar.xz";
        hash = "sha256-my5OQgYEx8mSnPfk3UtM20wc0Q5hnAuCkOohoRjOgu4=";
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
