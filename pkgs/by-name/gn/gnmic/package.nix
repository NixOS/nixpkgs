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
  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "openconfig";
    repo = "gnmic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z8+pQvK53FpeBla08TS8kGmDV+nyaliW9KBl/0ZNygM=";
  };

  vendorHash = "sha256-S+WluooN6Ob5Usvf+Vc6sExCCK8g350WGis1aW6Ejr4=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/openconfig/gnmic/pkg/version.Version=${finalAttrs.version}"
    "-X"
    "github.com/openconfig/gnmic/pkg/version.Commit=${finalAttrs.src.rev}"
    "-X"
    "github.com/openconfig/gnmic/pkg/version.Date=1970-01-01T00:00:00Z"
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
