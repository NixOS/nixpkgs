{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  asciidoctor,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "qrtool";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "sorairolake";
    repo = "qrtool";
    rev = "v${version}";
    hash = "sha256-ViDlY60iGNBwCDRgKiNKbsFSXozyzqlTzKpd9NCxrv0=";
  };

  cargoHash = "sha256-Bcu5hyW0uUHkshlBoKNG/NL0XYnrPJa/P8bHdcGjFTc=";

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
  ];

  postInstall =
    ''
      # Built by ./build.rs using `asciidoctor`
      installManPage ./target/*/release/build/qrtool*/out/*.?

    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd qrtool \
        --bash <($out/bin/qrtool --generate-completion bash) \
        --fish <($out/bin/qrtool --generate-completion fish) \
        --zsh <($out/bin/qrtool --generate-completion zsh)
    '';

  meta = with lib; {
    maintainers = with maintainers; [ philiptaron ];
    description = "Utility for encoding and decoding QR code images";
    license = licenses.asl20;
    homepage = "https://sorairolake.github.io/qrtool/book/index.html";
    changelog = "https://sorairolake.github.io/qrtool/book/changelog.html";
    mainProgram = "qrtool";
  };
}
