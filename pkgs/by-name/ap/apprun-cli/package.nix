{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "apprun-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "fujiwara";
    repo = "apprun-cli";
    tag = "v${version}";
    hash = "sha256-3M+kRXTQ0yaxQc9E5T9UThqEda2S1F77SJzX7burZlU=";
  };

  vendorHash = "sha256-i3ZthsZVxAYQDX6ZA1bU81F4BbYSsWdu1sOAiY7FK7Y=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      # Until a stable version is released, v0 tags are incorrectly recognized as the latest,
      # so specify minor releases
      "^v0.([0-9.]+)$"
    ];
  };

  meta = {
    description = "CLI for sakura AppRun";
    homepage = "https://github.com/fujiwara/apprun-cli";
    changelog = "https://github.com/fujiwara/apprun-cli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "apprun-cli";
  };
}
