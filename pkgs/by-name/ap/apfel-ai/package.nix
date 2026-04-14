{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "apfel-ai";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/Arthur-Ficial/apfel/releases/download/v${finalAttrs.version}/apfel-${finalAttrs.version}-arm64-macos.tar.gz";
    hash = "sha256-xxPTFpaQ9/CQLyMKy30yUaTIvO7A6ml8tZGlV4L+CGg=";
  };

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 apfel $out/bin/apfel
    runHook postInstall
  '';

  # The binary is self-contained (static Swift runtime + system frameworks)
  # so no fixup is needed beyond the default install-name handling.

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "On-device LLM CLI using Apple FoundationModels (distinct from the 'apfel' physics library)";
    longDescription = ''
      apfel exposes Apple's on-device FoundationModels LLM as a UNIX tool,
      an OpenAI-compatible HTTP server (drop-in replacement for
      http://localhost:11434/v1), and an interactive command-line chat.

      100% on-device - no cloud, no API keys, no network for inference.

      Runtime requirements (Nix cannot enforce these at build time):
        * macOS 26 "Tahoe" or later
        * Apple Silicon (aarch64-darwin)
        * Apple Intelligence enabled in System Settings -> Apple Intelligence & Siri
        * Siri language matching device language

      This derivation installs the official pre-built release binary from
      GitHub because apfel links against Apple's FoundationModels system
      framework, which requires the macOS 26 SDK and Apple Silicon at
      build time. Building from source in the nixpkgs darwin stdenv is
      not currently supported.
    '';
    homepage = "https://github.com/Arthur-Ficial/apfel";
    changelog = "https://github.com/Arthur-Ficial/apfel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arthur-ficial ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "apfel";
  };
})
