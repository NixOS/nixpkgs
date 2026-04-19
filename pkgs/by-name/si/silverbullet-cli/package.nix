{
  autoPatchelfHook,
  common-updater-scripts,
  fetchurl,
  lib,
  stdenv,
  stdenvNoCC,
  unzip,
  writeShellScript,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "silverbullet-cli";
  version = "2.6.1";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontUnpack = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ] ++ [ unzip ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    unzip -j $src silverbullet-cli -d $out/bin
    chmod +x $out/bin/silverbullet-cli
    runHook postInstall
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-cli-linux-x86_64.zip";
        hash = "sha256-zE8phpI69COeuJ7yOG5jPo/Qp4TjxmyHD4rOsaIwCrI=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-cli-linux-aarch64.zip";
        hash = "sha256-nrTjWWUUdeQSsPKHqoIYNkNAhmEjeqVWDWjMHyhQfPQ=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-cli-darwin-x86_64.zip";
        hash = "sha256-OuWd0Iw/WZ97GbexhDkUXb+wDM5x+SJ4iGRINXan4Jw=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/silverbulletmd/silverbullet/releases/download/${finalAttrs.version}/silverbullet-cli-darwin-aarch64.zip";
        hash = "sha256-7WMoHBfEVSFatLmKuEegSp02sAe4zt5csHrzDq/11ng=";
      };
    };

    updateScript = writeShellScript "update-silverbullet-cli" ''
      NEW_VERSION="$1"
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        ${lib.getExe' common-updater-scripts "update-source-version"} "silverbullet-cli" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    changelog = "https://github.com/silverbulletmd/silverbullet/blob/${finalAttrs.version}/website/CHANGELOG.md";
    description = "CLI for driving a remote SilverBullet server";
    homepage = "https://silverbullet.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aorith ];
    mainProgram = "silverbullet-cli";
    platforms = builtins.attrNames finalAttrs.passthru.sources;
  };
})
