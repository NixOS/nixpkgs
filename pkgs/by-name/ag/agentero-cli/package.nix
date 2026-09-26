{
  autoPatchelfHook,
  fetchurl,
  lib,
  nix-update-script,
  openssl,
  stdenv,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "agentero-cli";
  version = "0.11.4";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/poco-ai/Agentero/releases/download/v${finalAttrs.version}/agentero-cli-${finalAttrs.version}-x86_64-unknown-linux-gnu.tar.gz";
    hash = "sha256-GLbwxeb6Pgw0hnuE0cEXzFpzRdoQIqCQVUXxKteeS8A=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    openssl
    stdenv.cc.cc.lib
    zlib
  ];

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    tar -xzf "$src" -C "$out/bin" agentero
    mv "$out/bin/agentero" "$out/bin/agentero-cli"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "Command-line interface for Agentero";
    homepage = "https://github.com/poco-ai/Agentero";
    changelog = "https://github.com/poco-ai/Agentero/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ign1x ];
    mainProgram = "agentero-cli";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
