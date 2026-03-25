{
  autoPatchelfHook,
  common-updater-scripts,
  fetchzip,
  lib,
  nixosTests,
  stdenv,
  stdenvNoCC,
  writeShellScript,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "silverbullet";
  version = "2.5.2";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/silverbullet $out/bin/
    runHook postInstall
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchzip {
        url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-server-linux-x86_64.zip";
        hash = "sha256-OvwFYPxR6N/njtaaNX0TolgRxZnhX3qBIvT2okoy2cQ=";
        stripRoot = false;
      };
      "aarch64-linux" = fetchzip {
        url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-server-linux-aarch64.zip";
        hash = "sha256-+VhgiAvDApb7Xi3Ob+fDpq1LrhmqAANZGjLsyhbmfNQ=";
        stripRoot = false;
      };
      "x86_64-darwin" = fetchzip {
        url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-server-darwin-x86_64.zip";
        hash = "sha256-jC39IZlFRnZ86I6JMXaaEyET4jwmOI0XKohxxr4VvZc=";
        stripRoot = false;
      };
      "aarch64-darwin" = fetchzip {
        url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-server-darwin-aarch64.zip";
        hash = "sha256-7njnFI3Ui7+6/kmbdCeEZ4f4gXKfzIx3YCfyB99k/f4=";
        stripRoot = false;
      };
    };

    updateScript = writeShellScript "update-silverbullet" ''
      NEW_VERSION="$1"
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        ${lib.getExe' common-updater-scripts "update-source-version"} "silverbullet" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';

    tests = {
      inherit (nixosTests) silverbullet;
    };
  };

  meta = {
    changelog = "https://github.com/silverbulletmd/silverbullet/blob/${finalAttrs.version}/website/CHANGELOG.md";
    description = "Open-source, self-hosted, offline-capable Personal Knowledge Management (PKM) web application";
    homepage = "https://silverbullet.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aorith ];
    mainProgram = "silverbullet";
    platforms = builtins.attrNames finalAttrs.passthru.sources;
  };
})
