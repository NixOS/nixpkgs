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
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "spacelift-io";
    repo = "spacectl";
    rev = "v${version}";
    hash = "sha256-TDJnXOzzi5VunXyxz8XYOZDZVAdEuWkp3fXu5sZJydc=";
  };

  vendorHash = "sha256-iyB6GFkTa4ci+TC2mDTtkuqCXFBnz3rwLns+3ovkUxg=";

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
