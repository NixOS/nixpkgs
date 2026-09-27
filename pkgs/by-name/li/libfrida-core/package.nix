{
  lib,
  stdenvNoCC,
  fetchurl,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "libfrida-core";
  version = "17.18.0";

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
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
      x86_64-linux = fetchurl {
        url = "https://github.com/frida/frida/releases/download/${finalAttrs.version}/frida-core-devkit-${finalAttrs.version}-linux-x86_64.tar.xz";
        hash = "sha256-NVfE1VcY2UtCE5TxN9uWqZeQFHI4i+3kzJf80qWbgDc=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/frida/frida/releases/download/${finalAttrs.version}/frida-core-devkit-${finalAttrs.version}-linux-arm64.tar.xz";
        hash = "sha256-Nl8QKGiYEkc5PoPQWeneEUqIjTyQnuIa+8nZl8QkxKI=";
      };
      aarch64-darwin = fetchurl {
        url = "https://github.com/frida/frida/releases/download/${finalAttrs.version}/frida-core-devkit-${finalAttrs.version}-macos-arm64.tar.xz";
        hash = "sha256-MmyRjD67EUjiRQMNvCIcP/hYB1zdt6W/N0JBg/idEu4=";
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
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "libfrida-core" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Frida core library intended for static linking into bindings";
    homepage = "https://frida.re/";
    changelog = "https://frida.re/news/";
    license = lib.licenses.wxWindowsException31;
    maintainers = with lib.maintainers; [ nilathedragon ];
    platforms = builtins.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
