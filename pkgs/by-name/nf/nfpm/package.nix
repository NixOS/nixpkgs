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
  version = "2.49.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "nfpm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1gp6OfFe3wxuZD1NgDTJnoAktfIX/ohMJ8u+gOTL9T8=";
  };

  vendorHash = "sha256-J9PdbngHNgnhv+s53/E5hY41Cn9BQzv1jAAO33+8rTA=";

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
    license = lib.licenses.mit;
    mainProgram = "nfpm";
  };
})
