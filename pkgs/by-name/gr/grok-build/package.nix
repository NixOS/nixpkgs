{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  versionCheckHook,
}:

let
  version = "0.1.210"; # = contents of .../cli/stable
  base = "https://storage.googleapis.com/grok-build-public-artifacts/cli";

  # upstream publishes no x86_64-darwin artifact
  sources = {
    x86_64-linux = {
      url = "${base}/grok-${version}-linux-x86_64";
      hash = "sha256-IowYyhIcRXfB1G/qne1DiCAs0B2MKz0zG1E3RPoGx5k=";
    };
    aarch64-linux = {
      url = "${base}/grok-${version}-linux-aarch64";
      hash = "sha256-zskTsNseNf8XGV4u6MVhPhUITkj4bdK6Jxn23sb2+8I=";
    };
    aarch64-darwin = {
      url = "${base}/grok-${version}-macos-aarch64";
      hash = "sha256-uQZgdxkLqdZfWGf+LOzVy2pH4toDVVroQb+iMqhWiUQ=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "grok-build: unsupported platform ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "grok-build";
  inherit version;

  src = fetchurl { inherit (source) url hash; };

  dontUnpack = true;

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/grok
    ln -s grok $out/bin/agent
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "xAI's agentic coding CLI (Grok Build)";
    homepage = "https://x.ai/cli";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "grok";
    maintainers = with lib.maintainers; [ unreasonable0ne ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
