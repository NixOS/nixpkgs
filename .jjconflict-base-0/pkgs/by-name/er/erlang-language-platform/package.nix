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
    linux-aarch64-unknown-linux-gnu = "sha256-vWMrq/uFU/uyuDnsxZK0ZyvtraVCZwvGjzO1a5QjR8g=";
    linux-x86_64-unknown-linux-gnu = "sha256-iE/zH6M51C6sFZrsUMwZTQ0+hzfpRFJtiKh3MS9bDto=";
    macos-aarch64-apple-darwin = "sha256-55LSChvO0wRHGL0H29MLy/JW8V52GFr3z/qoxdIPun0=";
    macos-x86_64-apple-darwin = "sha256-l9bzQ5z9hQ/N2dOkAjPAU4OfRbLCUoRt1eQB6EZE0NI=";
  };
in
stdenv.mkDerivation rec {
  pname = "erlang-language-platform";
  version = "2024-07-16";

  src = fetchurl {
    url = "https://github.com/WhatsApp/erlang-language-platform/releases/download/${version}/elp-${release}-otp-26.2.tar.gz";
    hash = hashes.${release};
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

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
