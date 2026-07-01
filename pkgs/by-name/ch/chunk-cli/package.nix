{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chunk-cli";
  version = "0.6.1";

  src =
    let
      inherit (stdenv.hostPlatform) system;
      baseUrl = "https://github.com/CircleCI-Public/chunk-cli/releases/download/v${finalAttrs.version}";
      platform =
        {
          x86_64-linux = {
            asset = "chunk-cli_Linux_x86_64.tar.gz";
            hash = "sha256-c2shfzy/DVMty1bAlCfi2xH3BGNL9i3SaQeaOJVu9i8=";
          };
          aarch64-linux = {
            asset = "chunk-cli_Linux_arm64.tar.gz";
            hash = "sha256-wOFJpZTg9qb/Ci3YPKek6Ek8QKMV4gBVSXzl8W4qcog=";
          };
          x86_64-darwin = {
            asset = "chunk-cli_Darwin_x86_64.tar.gz";
            hash = "sha256-4rES26zi94eI0+cv9Q+fBx77zJB3NKHUASvwbzqZu0Q==";
          };
          aarch64-darwin = {
            asset = "chunk-cli_Darwin_arm64.tar.gz";
            hash = "sha256-lkjjraD3GVEllXdz1J1Pza+XYm6YQaJw3tbOFH0eofo=";
          };
        }
        .${system} or (throw "Unsupported system: ${system}");
    in
    fetchurl {
      url = "${baseUrl}/${platform.asset}";
      hash = platform.hash;
    };

  dontConfigure = true;
  dontBuild = true;

  # Tarball has no top-level directory (single binary), so extract into one
  unpackCmd = "mkdir -p chunk-cli && tar xf $curSrc -C chunk-cli";
  sourceRoot = "chunk-cli";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    binary=$(find . -type f -executable \( -name 'chunk' -o -name 'chunk-cli' \) 2>/dev/null | head -1)
    if [ -z "$binary" ]; then
      binary=$(find . -type f -executable 2>/dev/null | head -1)
    fi
    install -m755 "$binary" $out/bin/chunk
    runHook postInstall
  '';

  meta = {
    description = "Chunk CLI by CircleCI - context generation from PR review comments for AI coding guidance";
    homepage = "https://github.com/CircleCI-Public/chunk-cli";
    changelog = "https://github.com/CircleCI-Public/chunk-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "chunk";
    maintainers = with lib.maintainers; [ hanabelmengistu ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
