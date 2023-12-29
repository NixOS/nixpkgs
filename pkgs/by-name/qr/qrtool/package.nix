{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, asciidoctor
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "qrtool";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "sorairolake";
    repo = "qrtool";
    rev = "v${version}";
    sha256 = "sha256-96k3VgxVGuKPLA4rD9B20AigFW03YvedT04UUzzmX38=";
  };

  cargoHash = "sha256-nAfW66vasnR0JHhz7n1XGA+OpPavOnGB6D6TfK9cr9Y=";

  nativeBuildInputs = [ asciidoctor installShellFiles ];

  postInstall = ''
    # Built by ./build.rs using `asciidoctor`
    installManPage ./target/*/release/build/qrtool*/out/*.?

    installShellCompletion --cmd qrtool \
      --bash <($out/bin/qrtool --generate-completion bash) \
      --fish <($out/bin/qrtool --generate-completion fish) \
      --zsh <($out/bin/qrtool --generate-completion zsh)
  '';

  meta = with lib; {
    maintainers = with maintainers; [ philiptaron ];
    description = "A utility for encoding and decoding QR code images";
    license = licenses.asl20;
    homepage = "https://sorairolake.github.io/qrtool/book/index.html";
    changelog = "https://sorairolake.github.io/qrtool/book/changelog.html";
    mainProgram = "qrtool";
  };
}
