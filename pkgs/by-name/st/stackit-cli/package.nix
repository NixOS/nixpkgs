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
  version = "0.1.0-prerelease.2";

  src = fetchFromGitHub {
    owner = "stackitcloud";
    repo = "stackit-cli";
    rev = "v${version}";
    hash = "sha256-GS3ZXarhXs1xuVmiLPMrrzXnO79R1+2va0x7N7CKNjQ=";
  };

  vendorHash = "sha256-Cill5hq8KVeKGRX2u9oIudi/s8XHIW5C8sgbTshrLY4=";

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
