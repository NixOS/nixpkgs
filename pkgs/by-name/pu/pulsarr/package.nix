{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  autoPatchelfHook,
  runtimeShell,
  cctools,
  darwin,
  rcodesign,
}:
let
  platforms = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "macos-arm64";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pulsarr";
  version = "0.19.7";

  src = finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system};

  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  __structuredAttrs = true;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/pulsarr
    cp -r dist migrations node_modules packages package.json bun start.sh $out/lib/pulsarr/
    chmod +x $out/lib/pulsarr/bun
    substituteInPlace $out/lib/pulsarr/start.sh \
      --replace-fail '#!/bin/bash' '#!${runtimeShell}' \
      --replace-fail 'cd "$(dirname "''${BASH_SOURCE[0]}")"' "cd $out/lib/pulsarr"
    install -Dm644 .env.example $out/share/pulsarr/.env.example
    substitute ${./pulsarr.sh} $out/bin/pulsarr \
      --subst-var-by shell ${runtimeShell} \
      --subst-var-by defaultDataDir ${
        lib.escapeShellArg (
          if stdenvNoCC.hostPlatform.isDarwin then "$HOME/.config/Pulsarr" else "$PWD/data"
        )
      } \
      --subst-var out
    chmod +x $out/bin/pulsarr

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    ${lib.getExe' cctools "${cctools.targetPrefix}install_name_tool"} $out/lib/pulsarr/bun \
      -change /usr/lib/libicucore.A.dylib ${lib.getLib darwin.ICU}/lib/libicucore.A.dylib
    ${lib.getExe rcodesign} sign --code-signature-flags linker-signed $out/lib/pulsarr/bun
  '';

  passthru = {
    sources = lib.mapAttrs (
      system: platform:
      fetchurl {
        url = "https://github.com/jamcalli/Pulsarr/releases/download/v${finalAttrs.version}/pulsarr-v${finalAttrs.version}-${platform}.zip";
        hash =
          {
            x86_64-linux = "sha256-j968Aa2uULLcViJ4ukoqfZZ66bgjQ0/yISZ1IpEIxB8=";
            aarch64-linux = "sha256-REN35cahWs6GNYIPH/WeEH0OUnVpem2RY2gC+5icQfI=";
            aarch64-darwin = "sha256-GvOVU2gIp+HHTy2WAEiStSvOkECfM0ynDhFgEoST7sU=";
          }
          .${system};
      }
    ) platforms;
  };

  meta = {
    description = "Plex watchlist tracker and notification center for the Arr stack";
    homepage = "https://jamcalli.github.io/Pulsarr/";
    changelog = "https://github.com/jamcalli/Pulsarr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.jblik ];
    platforms = builtins.attrNames platforms;
    mainProgram = "pulsarr";
  };
})
