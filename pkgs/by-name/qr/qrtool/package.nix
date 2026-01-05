{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  asciidoctor,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qrtool";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "sorairolake";
    repo = "qrtool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ckdtmnUupnKAaspLm/l+nmPNdQ/sFAusQehzWikxq7A=";
  };

  cargoHash = "sha256-RGEHsMay7+sjmrKz4g6uFXt6fUFiu0xIjr4fQaARKIM=";

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
  ];

  postInstall = ''
    asciidoctor -b manpage docs/man/man1/*.1.adoc
    installManPage docs/man/man1/*.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd qrtool \
      --bash <($out/bin/qrtool completion bash) \
      --fish <($out/bin/qrtool completion fish) \
      --zsh <($out/bin/qrtool completion zsh)
  '';

  meta = {
    description = "Utility for encoding and decoding QR code images";
    license = lib.licenses.asl20;
    homepage = "https://sorairolake.github.io/qrtool/book/index.html";
    changelog = "https://sorairolake.github.io/qrtool/book/changelog.html";
    mainProgram = "qrtool";
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
