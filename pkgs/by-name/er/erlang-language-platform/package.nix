{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
}:
let
  arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
  release =
    if stdenv.hostPlatform.isDarwin then
      "macos-${arch}-apple-darwin"
    else
      "linux-${arch}-unknown-linux-gnu";

  hashes = {
    linux-aarch64-unknown-linux-gnu = "sha256-Fte7oZD5+aFph5xGrKtbSimb3aHewkjsJRXB+64IW5A=";
    linux-x86_64-unknown-linux-gnu = "sha256-GFf1YybZRyZ3D6ZnLf+op6KRPYbwBHSPh1groxdNZks=";
    macos-aarch64-apple-darwin = "sha256-3K3sPizBR/+DJIX67GsYqm2X5k7kq3kBRg8P2WALTZs=";
    macos-x86_64-apple-darwin = "sha256-j+AVmLfe/yCvKvYhL5ikhXA1g+zQ1CDlMl1FYO6q1yA=";
  };
in
stdenv.mkDerivation rec {
  pname = "erlang-language-platform";
  version = "2024-12-09";

  src = fetchurl {
    url = "https://github.com/WhatsApp/erlang-language-platform/releases/download/${version}/elp-${release}-otp-26.2.tar.gz";
    hash = hashes.${release};
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [ (lib.getLib stdenv.cc.cc) ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D elp $out/bin/elp
    runHook postInstall
  '';

  meta = {
    description = "An IDE-first library for the semantic analysis of Erlang code, including LSP server, linting and refactoring tools.";
    homepage = "https://github.com/WhatsApp/erlang-language-platform/";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ offsetcyan ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
