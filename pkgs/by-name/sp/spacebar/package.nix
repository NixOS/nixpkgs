{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk_12,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spacebar";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "cmacrae";
    repo = "spacebar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4LiG43kPZtsm7SQ/28RaGMpYsDshCaGvc1mouPG3jFM=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    apple-sdk_12
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 ./bin/spacebar $out/bin/spacebar
    installManpage ./doc/spacebar.1
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
