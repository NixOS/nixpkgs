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
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "spacelift-io";
    repo = "spacectl";
    rev = "v${version}";
    hash = "sha256-RC2ReS8XI0WHIXP1XhnBcsOxHQ3NhpQf4wByk8mfm8g=";
  };

  vendorHash = "sha256-t81t+Fx9cMfOSSzuCaqnyXvGOJ07JYk9mqPbR4HaHUk=";

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
