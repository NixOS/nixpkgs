{
  stdenvNoCC,
  lib,
  fetchurl,
  autoPatchelfHook,
  gzip,
  makeWrapper,
  ripgrep,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  cctools,
  darwin,
  rcodesign,
}:

let
  platforms = {
    # Upstream also publishes linux-x64, which is optimized for AVX2. Use the
    # baseline build for nixpkgs so the x86_64-linux package works on all
    # supported x86_64 CPUs instead of depending on the build user's CPU flags.
    x86_64-linux = "linux-x64-baseline";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };

in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "amp-cli";
  version = "0.0.1782120930-g64087b";

  src = finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system};

  nativeBuildInputs = [
    gzip
    makeWrapper
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];
  strictDeps = true;

  dontUnpack = true;
  dontStrip = true;
  dontFixup = !stdenvNoCC.hostPlatform.isLinux;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/amp-cli
    gunzip -c $src > $out/libexec/amp-cli/amp
    chmod +x $out/libexec/amp-cli/amp

    makeWrapper $out/libexec/amp-cli/amp $out/bin/amp \
      --set AMP_SKIP_UPDATE_CHECK 1 \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    '${lib.getExe' cctools "${cctools.targetPrefix}install_name_tool"}' $out/libexec/amp-cli/amp \
      -change /usr/lib/libicucore.A.dylib '${lib.getLib darwin.ICU}/lib/libicucore.A.dylib'
    '${lib.getExe rcodesign}' sign --code-signature-flags linker-signed $out/libexec/amp-cli/amp
  '';

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/amp";
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    sources = lib.mapAttrs (
      system': platform:
      fetchurl {
        url = "https://static.ampcode.com/cli/${finalAttrs.version}/amp-${platform}.gz";
        hash =
          {
            x86_64-linux = "sha256-Ye1ch/mmhFelSv77Yy+fbpiBUlXzInACp2Hux+CLQzk=";
            aarch64-linux = "sha256-cGV6tqiaHDjSCjhlSgAf0wIcOXY0Y78G2IT0ZQ5uuNk=";
            x86_64-darwin = "sha256-5UmALYPSfUceumD4puKbMY+VwUsmAojHuu3pNXxVOr4=";
            aarch64-darwin = "sha256-zzpPWKfYHAEXLNvAucVOwm0HE8Ui3Ai31XMs+utlXF4=";
          }
          .${system'};
      }
    ) platforms;
    updateScript = ./update.sh;
  };

  meta = {
    description = "CLI for Amp, an agentic coding agent in research preview from Sourcegraph";
    homepage = "https://ampcode.com/";
    downloadPage = "https://ampcode.com/install";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      keegancsmith
      burmudar
    ];
    mainProgram = "amp";
    platforms = builtins.attrNames platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
