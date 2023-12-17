{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, asciidoctor
, installShellFiles
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "qrtool";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "sorairolake";
    repo = "qrtool";
    rev = "v${version}";
    hash = "sha256-PXjggeDofrrS32XdqnOgAMlAiw+/7eMQpELw8EmiwNI=";
  };

  cargoHash = "sha256-0Vwx80XxrJX8C293+4qgRr0pTMV6Jy3IBNQISzFxyr0=";

  nativeBuildInputs = [ asciidoctor installShellFiles ];

  postInstall = ''
    # Built by ./build.rs using `asciidoctor`
    installManPage ./target/*/release/build/qrtool*/out/*.?

    installShellCompletion --cmd qrtool \
      --bash <($out/bin/qrtool --generate-completion bash) \
      --fish <($out/bin/qrtool --generate-completion fish) \
      --zsh <($out/bin/qrtool --generate-completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    maintainers = with maintainers; [ philiptaron ];
    description = "A utility for encoding and decoding QR code images";
    license = licenses.asl20;
    homepage = "https://sorairolake.github.io/qrtool/book/index.html";
    changelog = "https://sorairolake.github.io/qrtool/book/changelog.html";
    mainProgram = "qrtool";
  };
}
