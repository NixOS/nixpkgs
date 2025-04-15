{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "apprun-cli";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "fujiwara";
    repo = "apprun-cli";
    tag = "v${version}";
    hash = "sha256-SvFShjAHjIKhz/YolgmFeaAxflh3FRPEZDx57+AtXeQ=";
  };

  vendorHash = "sha256-pz97Eihc/6b2J+JuEZJQoqBkKtf1J5XbSFMQa1CJrRo=";

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
