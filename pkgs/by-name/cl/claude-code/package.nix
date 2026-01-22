# NOTE: Use the following command to update the package
# ```sh
# nix-shell maintainers/scripts/update.nix --argstr commit true --arg predicate '(path: pkg: builtins.elem path [["claude-code"] ["vscode-extensions" "anthropic" "claude-code"]])'
# ```
{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  cctools,
  darwin,
  rcodesign,
  procps,
  bubblewrap,
  socat,
}:
let
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  manifest = lib.importJSON ./manifest.json;
  platformKey = "${stdenv.hostPlatform.node.platform}-${stdenv.hostPlatform.node.arch}";
  platformManifestEntry = manifest.platforms.${platformKey};
in
stdenv.mkDerivation {
  pname = "claude-code";
  inherit (manifest) version;

  src = fetchurl {
    url = "${baseUrl}/${manifest.version}/${platformKey}/claude";
    sha256 = platformManifestEntry.checksum;
  };

  dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    rcodesign
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/claude

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1 \
      --prefix PATH : ${
        lib.makeBinPath (
          # claude-code uses [node-tree-kill](https://github.com/pkrumins/node-tree-kill) which requires procps's pgrep(darwin) or ps(linux)
          [ procps ]
          # the following packages are required for /sandbox command to work (Linux only)
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            bubblewrap
            socat
          ]
        )
      }
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ${lib.getExe' cctools "${cctools.targetPrefix}install_name_tool"} $out/bin/.claude-wrapped \
      -change /usr/lib/libicucore.A.dylib ${lib.getLib darwin.ICU}/lib/libicucore.A.dylib
    ${lib.getExe rcodesign} sign --code-signature-flags linker-signed $out/bin/.claude-wrapped
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://claude.com/product/claude-code";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ]; # Native distribution crashes on CPUs without AVX, including Rosetta 2 on Apple Silicon.
    # https://github.com/anthropics/claude-code/issues/19907
    hydraPlatforms = lib.lists.remove "x86_64-darwin" lib.platforms.all;
    maintainers = with lib.maintainers; [
      adeci
      malo
      markus1189
      omarjatoi
      xiaoxiangmoe
    ];
    mainProgram = "claude";
  };
}
