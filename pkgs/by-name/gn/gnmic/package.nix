{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:

buildGoModule (finalAttrs: {
  pname = "gnmic";
  version = "0.44.1";

  src = fetchFromGitHub {
    owner = "openconfig";
    repo = "gnmic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aAVjc5U0/fd9hOKCyVMopInkX4geJvuy48nHecKKzUQ=";
  };

  vendorHash = "sha256-V6tnsCszkruLnAOCCysOYmPioHNQpdsQu0GZUf+36SE=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/openconfig/gnmic/pkg/app.version=${finalAttrs.version}"
    "-X"
    "github.com/openconfig/gnmic/pkg/app.commit=${finalAttrs.src.rev}"
    "-X"
    "github.com/openconfig/gnmic/pkg/app.date=1970-01-01T00:00:00Z"
  ];
  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd gnmic \
        --bash <(${emulator} $out/bin/gnmic completion bash) \
        --fish <(${emulator} $out/bin/gnmic completion fish) \
        --zsh  <(${emulator} $out/bin/gnmic completion zsh)
    '';

  meta = {
    description = "gNMI CLI client and collector";
    homepage = "https://gnmic.openconfig.net/";
    changelog = "https://github.com/openconfig/gnmic/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vincentbernat ];
    mainProgram = "gnmic";
  };
})
