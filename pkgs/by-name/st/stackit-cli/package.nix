{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, less
, xdg-utils
, testers
, runCommand
, stackit-cli
}:

buildGoModule rec {
  pname = "stackit-cli";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "stackitcloud";
    repo = "stackit-cli";
    rev = "v${version}";
    hash = "sha256-0SI7hRJxdtdpGgEsUCWNsIcT50W7uyxLs5Mp+alHE0I=";
  };

  vendorHash = "sha256-FXy3qVSf57cPmxkY2XPEjFz3qRYkH5pPmCoIiWb28FY=";

  subPackages = [ "." ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  preCheck = ''
    export HOME=$TMPDIR # needed because the binary always creates a dir & config file
  '';

  postInstall = ''
    export HOME=$TMPDIR # needed because the binary always creates a dir & config file
    mv $out/bin/{${pname},stackit} # rename the binary

    installShellCompletion --cmd stackit --bash <($out/bin/stackit completion bash)
    installShellCompletion --cmd stackit --zsh <($out/bin/stackit completion zsh)
    installShellCompletion --cmd stackit --fish <($out/bin/stackit completion fish)
    # Use this instead, once https://github.com/stackitcloud/stackit-cli/issues/153 is fixed:
    # installShellCompletion --cmd stackit \
    #   --bash <($out/bin/stackit completion bash) \
    #   --zsh  <($out/bin/stackit completion zsh)  \
    #   --fish <($out/bin/stackit completion fish)
    # Ensure that all 3 completion scripts exist AND have content (should be kept for regression testing)
    [ $(find $out/share -not -empty -type f | wc -l) -eq 3 ]
  '';

  postFixup = ''
    wrapProgram $out/bin/stackit \
      --suffix PATH : ${lib.makeBinPath [ less xdg-utils ]}
  '';

  nativeCheckInputs = [ less ];

  passthru.tests = {
    version = testers.testVersion {
      package = stackit-cli;
      command = "HOME=$TMPDIR stackit --version";
    };
  };

  meta = with lib; {
    description = "CLI to manage STACKIT cloud services";
    homepage = "https://github.com/stackitcloud/stackit-cli";
    changelog = "https://github.com/stackitcloud/stackit-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ DerRockWolf ];
    mainProgram = "stackit";
  };
}
