{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:

buildGoModule rec {
  pname = "spacectl";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "spacelift-io";
    repo = "spacectl";
    rev = "v${version}";
    hash = "sha256-pT0e0HWryv8LYoKDJDAJ2936aZZ5LlukY6Z2OQesZAE=";
  };

  vendorHash = "sha256-VfhbwbKQOmXzLjS/O8BDdYHtZT2kBuxRcAPpHMlenUc=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd spacectl \
        --bash <(${emulator} $out/bin/spacectl completion bash) \
        --fish <(${emulator} $out/bin/spacectl completion fish) \
        --zsh <(${emulator} $out/bin/spacectl completion zsh) \
    '';

  meta = {
    homepage = "https://github.com/spacelift-io/spacectl";
    description = "Spacelift client and CLI";
    changelog = "https://github.com/spacelift-io/spacectl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "spacectl";
  };
}
