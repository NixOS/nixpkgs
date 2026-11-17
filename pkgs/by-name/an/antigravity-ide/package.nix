{
  lib,
  stdenv,
  buildVscode,
  fetchurl,
  applyPatches,
  antigravity-cli,
  writeShellScript,
  coreutils,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:

let
  inherit (stdenv) hostPlatform;
  information = (lib.importJSON ./information.json);
  source =
    information.sources."${hostPlatform.system}"
      or (throw "antigravity-ide: unsupported system ${hostPlatform.system}");
  src = fetchurl { inherit (source) url sha256; };
in
buildVscode {
  inherit commandLineArgs useVSCodeRipgrep;
  inherit (information) version vscodeVersion;
  pname = "antigravity-ide";

  executableName = "antigravity-ide";
  longName = "Antigravity IDE";
  shortName = "Antigravity IDE";
  libraryName = "antigravity-ide";
  iconName = "antigravity-ide";

  src =
    if hostPlatform.isLinux then
      applyPatches {
        name = "source";
        inherit src;
        sourceRoot = "Antigravity IDE";
        postPatch = ''
          # Use packaged agy instead of downloading an unpatched binary.
          substituteInPlace resources/app/extensions/agy/vscode/extension.js \
            --replace-fail 'getInstalledTargetPath(){return ec()}' \
              'getInstalledTargetPath(){return "${lib.getExe antigravity-cli}"}' \
            --replace-fail 'this.binaryAcquirer=Oc;' \
              'this.binaryAcquirer=async(options)=>{
              options.outputChannel.appendLine("[INSTALL] Using Nix-packaged agy at ${lib.getExe antigravity-cli}");
              options.onBinaryCheck?.({cacheHit:true,downloadReason:"up_to_date",cliVersion:"${antigravity-cli.version}"});
              return this.getInstalledTargetPath();
            };'
        '';
      }
    else
      src;

  sourceRoot = if hostPlatform.isDarwin then "Antigravity IDE.app" else "source";

  tests = { };
  updateScript = ./update.js;

  # When running inside an FHS environment, try linking Google Chrome or Chromium
  # to the hardcoded Playwright search path: /opt/google/chrome/chrome
  customizeFHSEnv =
    args:
    args
    // {
      extraBwrapArgs = (args.extraBwrapArgs or [ ]) ++ [ "--tmpfs /opt/google/chrome" ];
      extraBuildCommands = (args.extraBuildCommands or "") + ''
        mkdir -p "$out/opt/google/chrome"
      '';
      runScript = writeShellScript "antigravity-ide-wrapper" ''
        for candidate in google-chrome-stable google-chrome chromium-browser chromium; do
          if target=$(command -v "$candidate"); then
            ${coreutils}/bin/ln -sf "$target" /opt/google/chrome/chrome
            break
          fi
        done
        exec ${args.runScript} "$@"
      '';
    };

  meta = {
    mainProgram = "antigravity-ide";
    description = "Agentic development platform, evolving the IDE into the agent-first era";
    homepage = "https://antigravity.google/product/antigravity-ide";
    downloadPage = "https://antigravity.google/download#antigravity-ide";
    changelog = "https://antigravity.google/docs/changelog?tab=ide";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      Zaczero
      schembriaiden
    ];
  };
}
