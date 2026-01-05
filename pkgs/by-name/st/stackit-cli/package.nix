{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  less,
  xdg-utils,
  testers,
  stackit-cli,
}:

buildGoModule rec {
  pname = "stackit-cli";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "stackitcloud";
    repo = "stackit-cli";
    rev = "v${version}";
    hash = "sha256-+bBXpsdF9VSephh8mw8X5ysy+iOCsCEy4Pc9N4IJ42M=";
  };

  vendorHash = "sha256-QR4/f02vtYLaxP+g0Nm87BFUANcjp72psdbtrmfnmAM=";

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    mv $out/bin/{stackit-cli,stackit} # rename the binary

    installShellCompletion --cmd stackit \
      --bash <($out/bin/stackit completion bash) \
      --zsh  <($out/bin/stackit completion zsh)  \
      --fish <($out/bin/stackit completion fish)
    # Ensure that all 3 completion scripts exist AND have content (should be kept for regression testing)
    [ $(find $out/share -not -empty -type f | wc -l) -eq 3 ]
  '';

  postFixup = ''
    wrapProgram $out/bin/stackit \
      --suffix PATH : ${
        lib.makeBinPath [
          less
          xdg-utils
        ]
      }
  '';

  nativeCheckInputs = [ less ];

  passthru.tests = {
    version = testers.testVersion {
      package = stackit-cli;
      command = "stackit --version";
    };
  };

  meta = {
    description = "CLI to manage STACKIT cloud services";
    homepage = "https://github.com/stackitcloud/stackit-cli";
    changelog = "https://github.com/stackitcloud/stackit-cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ DerRockWolf ];
    mainProgram = "stackit";
  };
}
