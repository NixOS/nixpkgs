{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "apprun-cli";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "fujiwara";
    repo = "apprun-cli";
    tag = "v${version}";
    hash = "sha256-k8ZFDWIuUjYqDIm7JdiqjeF2qaPX0SaOgqk4oud09Lc=";
  };

  vendorHash = "sha256-WQRDkxL52RQmZn2aeE13pU4YGk8UjuZtS1lTNb53/hQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for sakura AppRun";
    homepage = "https://github.com/fujiwara/apprun-cli";
    changelog = "https://github.com/fujiwara/apprun-cli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "apprun-cli";
  };
}
