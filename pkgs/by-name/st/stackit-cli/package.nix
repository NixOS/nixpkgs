{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, less
, xdg-utils
, testers
, stackit-cli
}:

buildGoModule rec {
  pname = "stackit-cli";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "stackitcloud";
    repo = "stackit-cli";
    rev = "v${version}";
    hash = "sha256-ioV5ki2Jkbo/Ax9XDp/gm9NFTFS9604VAwOgs8wkoKU=";
  };

  vendorHash = "sha256-1MM4P4eLBZvYgmdYjaihe30qnCvTuY7ZHnAZei3dHhQ=";

  subPackages = [ "." ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

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
      --suffix PATH : ${lib.makeBinPath [ less xdg-utils ]}
  '';

  nativeCheckInputs = [ less ];

  passthru.tests = {
    version = testers.testVersion {
      package = stackit-cli;
      command = "stackit --version";
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
