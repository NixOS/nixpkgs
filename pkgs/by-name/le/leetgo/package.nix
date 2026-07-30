{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "leetgo";
  version = "1.4.17";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "leetgo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FxXU1A9pnVMzD0fTo2QgZvZYC40UwHlJja69WCCXD0k=";
  };

  vendorHash = "sha256-ODSzzEj7r8itbsEeXutLyXxGZ/7q7BZbGQ1kRN4RSfc=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/j178/leetgo/constants.Version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd leetgo \
      --bash <($out/bin/leetgo completion bash) \
      --fish <($out/bin/leetgo completion fish) \
      --zsh <($out/bin/leetgo completion zsh)
  '';

  meta = {
    description = "Command-line tool for LeetCode";
    homepage = "https://github.com/j178/leetgo";
    changelog = "https://github.com/j178/leetgo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Ligthiago ];
    mainProgram = "leetgo";
  };
})
