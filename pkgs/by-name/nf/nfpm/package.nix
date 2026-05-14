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
  version = "2.46.3";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "nfpm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BdiBEYCO8+YDFI4jKjRBaXtR/XutgBIzJA1xERRtE0U=";
  };

  vendorHash = "sha256-cDl/vdnklQJQpSrDHDrC2+K7YiBqPOY3Mv5ApOc63Cw=";

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
