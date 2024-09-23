{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "aliae";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = "aliae";
    rev = "refs/tags/v${version}";
    hash = "sha256-slixB7mzEdX3ecgbM6tO9IzVH+1w6DwssD1X3MrwAHw=";
  };

  vendorHash = "sha256-U0Mt2U8WxDFDadIxASz609tUtiF4tETobAmYrk29Lh0=";

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

  postInstall =
    ''
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
