{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "apprun-cli";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "fujiwara";
    repo = "apprun-cli";
    tag = "v${version}";
    hash = "sha256-tBQgBu/5GDphkpb/c+NoUCAvcrlbjR8nABp8a+3Lr1U=";
  };

  vendorHash = "sha256-V+yVp59fA3g4NRtsuUTAetmrO0bIyfFMAJRsD6G+QgE=";

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
