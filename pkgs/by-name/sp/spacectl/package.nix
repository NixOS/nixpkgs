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
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "spacelift-io";
    repo = "spacectl";
    rev = "v${version}";
    hash = "sha256-UNucwxFafGiMimbOeYVbz1+udW8faJ+Y8/QDW7HRFtc=";
  };

  vendorHash = "sha256-L0Dm9LymnXLMj6Yv+K4x85VsH+QKfSnVsOPLXHZ/Knc=";

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
