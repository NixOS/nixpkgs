{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:

buildGoModule rec {
  pname = "nfpm";
  version = "2.43.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = "nfpm";
    rev = "v${version}";
    hash = "sha256-HbGO4+wFp2mRBOKNxbnZ9sHUJS25ZQ4RaC1Eaw0kfrg=";
  };

  vendorHash = "sha256-BN+ruaajQuvFa/tECI9s0no6+EFR7BYoa1+Z/YI1PbY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
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
    changelog = "https://github.com/goreleaser/nfpm/releases/tag/v${version}";
    maintainers = with lib.maintainers; [
      techknowlogick
      caarlos0
    ];
    license = with lib.licenses; [ mit ];
    mainProgram = "nfpm";
  };
}
