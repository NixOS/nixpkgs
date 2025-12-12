{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "aliae";
  version = "0.26.6";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = "aliae";
    tag = "v${version}";
    hash = "sha256-W/jj2YQc6M0ro4groCynly2stjv2FLAMvIopnQYCngY=";
  };

  vendorHash = "sha256-8YTyhjF0p2l76sowq92ts5TjjcARToOfJN9nlFu19L4=";

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  tags = [
    "netgo"
    "osusergo"
  ];

  postInstall = ''
    mv $out/bin/{src,aliae}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd aliae \
      --bash <($out/bin/aliae completion bash) \
      --fish <($out/bin/aliae completion fish) \
      --zsh <($out/bin/aliae completion zsh)
  '';

  meta = {
    description = "Cross shell and platform alias management";
    mainProgram = "aliae";
    homepage = "https://aliae.dev";
    changelog = "https://github.com/JanDeDobbeleer/aliae/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vedantmgoyal9 ];
  };
}
