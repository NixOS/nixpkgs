{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, asciidoctor
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "qrtool";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "sorairolake";
    repo = "qrtool";
    rev = "v${version}";
    sha256 = "sha256-IK+ltZIiJDzD5vPbAQrQlXjAT5+hPb9layzBjXC7yl4=";
  };

  cargoHash = "sha256-ARKlbf2C6KYain9ET3kyzElXWk8SHM5M/RPUbYqLJ6o=";

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
