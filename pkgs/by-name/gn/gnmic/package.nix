{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
}:

buildGoModule rec {
  pname = "gnmic";
  version = "0.42.1";

  src = fetchFromGitHub {
    owner = "openconfig";
    repo = "gnmic";
    tag = "v${version}";
    hash = "sha256-mcgre0HmAR2L92HBlK8jdqlOqINI/NswgZUrSI//c8k=";
  };

  vendorHash = "sha256-u4tLuD8CuS3BzWJHDpphtkjgB0zkzBpP3FWrRWNgyJM=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/openconfig/gnmic/pkg/app.version=${version}"
    "-X"
    "github.com/openconfig/gnmic/pkg/app.commit=${src.rev}"
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

  meta = with lib; {
    description = "gNMI CLI client and collector";
    homepage = "https://gnmic.openconfig.net/";
    changelog = "https://github.com/openconfig/gnmic/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ vincentbernat ];
    mainProgram = "gnmic";
  };
}
