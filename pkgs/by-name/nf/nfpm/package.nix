{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:

buildGoModule (finalAttrs: {
  pname = "nfpm";
  version = "2.45.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "nfpm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MzxN4oQFmhnuR8T5wa5AGKjL+LhlTSBd2tGVf9WsCBc=";
  };

  vendorHash = "sha256-cq0pcbC0T3klh3D9l0e0u5JPYv1kWYlpeNYyGczGX+A=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      ${emulator} $out/bin/nfpm man > nfpm.1
      installManPage ./nfpm.1
      installShellCompletion --cmd nfpm \
        --bash <(${emulator} $out/bin/nfpm completion bash) \
        --fish <(${emulator} $out/bin/nfpm completion fish) \
        --zsh  <(${emulator} $out/bin/nfpm completion zsh)
    '';

  meta = {
    description = "Simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    changelog = "https://github.com/goreleaser/nfpm/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      techknowlogick
      caarlos0
    ];
    license = with lib.licenses; [ mit ];
    mainProgram = "nfpm";
  };
})
