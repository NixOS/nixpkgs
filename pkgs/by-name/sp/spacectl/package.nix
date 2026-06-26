{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:

buildGoModule (finalAttrs: {
  pname = "spacectl";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "spacelift-io";
    repo = "spacectl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2wy5I3wmBtp239gdcL8s+SuXWajx9EB+s3xBYxy55ok=";
  };

  vendorHash = "sha256-+ahiiboLKu/LazJzsxoE39hbF73TSuguPkKCSS7m2BA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd spacectl \
        --bash <(${emulator} $out/bin/spacectl completion bash) \
        --fish <(${emulator} $out/bin/spacectl completion fish) \
        --zsh <(${emulator} $out/bin/spacectl completion zsh)
    '';

  meta = {
    homepage = "https://github.com/spacelift-io/spacectl";
    description = "Spacelift client and CLI";
    changelog = "https://github.com/spacelift-io/spacectl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "spacectl";
  };
})
