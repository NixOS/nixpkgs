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
    linux-aarch64-unknown-linux-gnu = "sha256-i6XsOK8csrJ/9TDzltA7mGjdutLZONFiYGV5tqSCy8o=";
    linux-x86_64-unknown-linux-gnu = "sha256-XK3DPWIdPDoIL10EATa8p1bnlpZaOzOdU0LnuKbj++E=";
    macos-aarch64-apple-darwin = "sha256-8e5duQYDVFyZejMjuZPuWhg1on3CBku9eBuilG5p1BY=";
    macos-x86_64-apple-darwin = "sha256-dnouUBUUAkMr1h+IJWYamxmk8IC7JdeIUS9/YI0GzOU=";
  };
in
stdenv.mkDerivation rec {
  pname = "erlang-language-platform";
  version = "2025-04-02";

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
    description = "IDE-first library for the semantic analysis of Erlang code, including LSP server, linting and refactoring tools";
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
