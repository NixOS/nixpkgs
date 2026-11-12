{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "cheat";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    tag = finalAttrs.version;
    hash = "sha256-0c8NZzzLxssMJffEWBI5L3leWWOU/Y0slPIg6bPKzfI=";
  };

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    git
  ];

  postInstall = ''
    installManPage doc/cheat.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cheat \
      --bash <($out/bin/cheat --completion bash) \
      --fish <($out/bin/cheat --completion fish) \
      --zsh <($out/bin/cheat --completion zsh)
  '';

  vendorHash = null;

  doCheck = true;

  env.EDITOR = "cat";

  meta = {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with lib.maintainers; [ mic92 ];
    license = with lib.licenses; [
      gpl3
      mit
    ];
    inherit (finalAttrs.src.meta) homepage;
    mainProgram = "cheat";
  };
})
