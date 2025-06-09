{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk_12,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spacebar";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "cmacrae";
    repo = "spacebar";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-4LiG43kPZtsm7SQ/28RaGMpYsDshCaGvc1mouPG3jFM=";
  };

  buildInputs = [
    apple-sdk_12
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 spacebar $out/bin
    install -Dm644 ./doc/spacebar.1 $out/share/man/man1/spacebar.1
    runHook postInstall
  '';

  meta = {
    description = "Minimal status bar for macOS";
    homepage = "https://github.com/cmacrae/spacebar";
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ cmacrae ];
    license = lib.licenses.mit;
  };
})
