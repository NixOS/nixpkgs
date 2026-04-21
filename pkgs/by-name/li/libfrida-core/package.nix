{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "17.9.1";
  source =
    {
      x86_64-linux = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-x86_64.tar.xz";
        hash = "sha256-94Zk7onepdNVEeDb+Vn4h680UoXCZPeZW+eGpaUrnwI=";
      };
      aarch64-linux = {
        url = "https://github.com/frida/frida/releases/download/${version}/frida-core-devkit-${version}-linux-arm64.tar.xz";
        hash = "sha256-o9kJvxqHICzuFItPj6r76D8aEEF/8QsRwJvE4oxphfA=";
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
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
