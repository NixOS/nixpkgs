{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "aliae";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = "aliae";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/n20oNQGcfji2whdl/DaUUf2kgiVZMB73veUfOr9EqU=";
  };

  vendorHash = "sha256-qY12bkwa8lyHtS7AdvkKuAmwDRyn5am2aU6wy8GE4Wk=";

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
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
    changelog = "https://github.com/JanDeDobbeleer/aliae/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vedantmgoyal9 ];
  };
})
