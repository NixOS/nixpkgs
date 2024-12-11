{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "aliae";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = "aliae";
    rev = "refs/tags/v${version}";
    hash = "sha256-eJvtO5VL8miafrLQELSQB6/G2wUzTSdmeYW3j/AB3PU=";
  };

  vendorHash = "sha256-bZG73TKU1vB0Ll/n+VndGZq+cpZRLvGdSAuJNiQwZ94=";

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
