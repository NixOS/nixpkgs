{
  lib,
  stdenv,
  buildVscode,
  fetchurl,
  jq,
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
      or (throw "antigravity: unsupported system ${hostPlatform.system}");
in
(buildVscode {
  inherit commandLineArgs useVSCodeRipgrep;
  inherit (information) version vscodeVersion;
  pname = "antigravity";

  executableName = "antigravity";
  longName = "Antigravity";
  shortName = "Antigravity";
  libraryName = "antigravity";
  iconName = "antigravity";

  src = fetchurl { inherit (source) url sha256; };

  sourceRoot = if hostPlatform.isDarwin then "Antigravity.app" else "Antigravity";

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
      runScript = writeShellScript "antigravity-wrapper" ''
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
    mainProgram = "antigravity";
    description = "Agentic development platform, evolving the IDE into the agent-first era";
    homepage = "https://antigravity.google";
    downloadPage = "https://antigravity.google/download";
    changelog = "https://antigravity.google/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      Zaczero
    ];
  };
}).overrideAttrs
  (oldAttrs: {
    # Disable update checks
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ jq ];
    postPatch = (oldAttrs.postPatch or "") + ''
      productJson="${
        if stdenv.hostPlatform.isDarwin then "Contents/Resources" else "resources"
      }/app/product.json"
      data=$(jq 'del(.updateUrl)' "$productJson")
      echo "$data" > "$productJson"
    '';
  })
