{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  prebuilds =
    {
      aarch64-darwin = {
        frida = {
          url = "https://github.com/frida/frida/releases/download/17.6.2/frida-v17.6.2-napi-v8-darwin-arm64.tar.gz";
          hash = "sha256-47kQG90h/puHAr018ESk6dLgQPziWg7hheMQp2rL1MI=";
        };
        frida16 = {
          url = "https://github.com/frida/frida/releases/download/16.7.19/frida-v16.7.19-napi-v8-darwin-arm64.tar.gz";
          hash = "sha256-KmDxDXGA6FxFhGY3SNvRriU/SJfXw6XkNOX6O0CtNpY=";
        };
      };
      x86_64-darwin = {
        frida = {
          url = "https://github.com/frida/frida/releases/download/17.6.2/frida-v17.6.2-napi-v8-darwin-x64.tar.gz";
          hash = "sha256-JJkC1Pjzbp3TIUPr7Xytw2yd3qf9WVrZbm69WCbseTo=";
        };
        frida16 = {
          url = "https://github.com/frida/frida/releases/download/16.7.19/frida-v16.7.19-napi-v8-darwin-x64.tar.gz";
          hash = "sha256-bnRd2BLK7XJFZvL1aJFNQ/2eI5QrMaKD4o++1/XrE6c=";
        };
      };
      aarch64-linux = {
        frida = {
          url = "https://github.com/frida/frida/releases/download/17.6.2/frida-v17.6.2-napi-v8-linux-arm64.tar.gz";
          hash = "sha256-TChoxZGLDVhYQ05iZmP/WzP+SGVvrwQvBPYEkha/TrI=";
        };
        frida16 = {
          url = "https://github.com/frida/frida/releases/download/16.7.19/frida-v16.7.19-napi-v8-linux-arm64.tar.gz";
          hash = "sha256-OImdJ/VGEkPi63TVf08T8N+qo/qxYCofdnatiocMDCc=";
        };
      };
      x86_64-linux = {
        frida = {
          url = "https://github.com/frida/frida/releases/download/17.6.2/frida-v17.6.2-napi-v8-linux-x64.tar.gz";
          hash = "sha256-9rmXqwLGc+oIPh02ty4z8TytNUUAHvo5dVsRsxtAISI=";
        };
        frida16 = {
          url = "https://github.com/frida/frida/releases/download/16.7.19/frida-v16.7.19-napi-v8-linux-x64.tar.gz";
          hash = "sha256-5+dDsi/3lnyoV4kdwp2r3+/AbdhdUE4HByTDY1tJgok=";
        };
      };
    }
    .${system} or (throw "Unsupported system: ${system}");
in
stdenvNoCC.mkDerivation {
  pname = "frida-node-prebuilds";
  version = "17.6.2-16.7.19";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/frida" "$out/frida16"
    tar -xzf ${fetchurl prebuilds.frida} -C "$out/frida"
    tar -xzf ${fetchurl prebuilds.frida16} -C "$out/frida16"

    runHook postInstall
  '';

  meta = {
    description = "Frida Node.js N-API prebuilt bindings (v17 and v16)";
    homepage = "https://frida.re/";
    changelog = "https://frida.re/news/";
    license = lib.licenses.wxWindowsException31;
    maintainers = with lib.maintainers; [ caverav ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
