{
  lib,
  stdenvNoCC,
  fetchurl,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:
let
  sourceSetName = if stdenvNoCC.hostPlatform.isMusl then "musl" else "defaultLibc";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libfrida-core";
  version = "17.24.3";

  src =
    finalAttrs.passthru.sources.${sourceSetName}.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system} with libc ${sourceSetName}");
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include $out/lib
    tar -xf $src -C .
    install -Dm755 libfrida-core.a -t $out/lib
    install -Dm644 frida-core.h -t $out/include
    runHook postInstall
  '';

  passthru = {
    sources = {
      defaultLibc = {
        x86_64-linux = fetchurl {
          url = "https://github.com/frida/frida/releases/download/${finalAttrs.version}/frida-core-devkit-${finalAttrs.version}-linux-x86_64.tar.xz";
          hash = "sha256-mhGr9HSJmjOvbdmvigZESLI5R6KaOvdH6zx4UVkf/sI=";
        };
        aarch64-linux = fetchurl {
          url = "https://github.com/frida/frida/releases/download/${finalAttrs.version}/frida-core-devkit-${finalAttrs.version}-linux-arm64.tar.xz";
          hash = "sha256-klvaDhYot7KC3aNw4pOrhK7arPwR0lk3juagiFqbmfc=";
        };
        aarch64-darwin = fetchurl {
          url = "https://github.com/frida/frida/releases/download/${finalAttrs.version}/frida-core-devkit-${finalAttrs.version}-macos-arm64.tar.xz";
          hash = "sha256-/zwL71rPmRu+FPAcUSSak++FLkreQYFuTiY2xBl2EaI=";
        };
      };
      musl = {
        x86_64-linux = fetchurl {
          url = "https://github.com/frida/frida/releases/download/${finalAttrs.version}/frida-core-devkit-${finalAttrs.version}-linux-x86_64-musl.tar.xz";
          hash = "sha256-7eMGo1suvEKYKhGOJqxv3PhMJ1WL2ApSfsRAUmQa5Zc=";
        };
        aarch64-linux = fetchurl {
          url = "https://github.com/frida/frida/releases/download/${finalAttrs.version}/frida-core-devkit-${finalAttrs.version}-linux-arm64-musl.tar.xz";
          hash = "sha256-u1yLKpTBRBQjOISJA0FvY24s1hDCwgI9jzvTpYv5FMQ=";
        };
      };
    };
    updateScript = writeShellScript "update-libfrida-core" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/frida/frida/releases/latest | jq '.tag_name' --raw-output)
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
        echo "The new version is the same as the old version."
        exit 0
      fi
      for source in ${
        lib.escapeShellArgs (
          lib.concatMap (
            libc: map (platform: "${libc}.${platform}") (builtins.attrNames finalAttrs.passthru.sources.${libc})
          ) (builtins.attrNames finalAttrs.passthru.sources)
        )
      }; do
        update-source-version "libfrida-core" "$NEW_VERSION" --ignore-same-version --source-key="sources.$source"
      done
    '';
  };

  meta = {
    description = "Frida core library intended for static linking into bindings";
    homepage = "https://frida.re/";
    changelog = "https://frida.re/news/";
    license = lib.licenses.wxWindowsException31;
    maintainers = with lib.maintainers; [ nilathedragon ];
    platforms = builtins.attrNames finalAttrs.passthru.sources.${sourceSetName};
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
