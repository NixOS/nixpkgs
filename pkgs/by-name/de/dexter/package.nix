{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "dexter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "remoteoss";
    repo = "dexter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BmWzrbC9ka8L1/mrPOXJqnoi1YVXxRcg6tSkb8tI88Q=";
  };

  vendorHash = "sha256-1mJ4HdDCsZl/g8F+L+NrW2ACuiHe2aSheJO/1XfKAb4=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/dexter
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dexter \
      --bash <($out/bin/dexter completion bash) \
      --fish <($out/bin/dexter completion fish) \
      --zsh <($out/bin/dexter completion zsh)
  '';

  __structuredAttrs = true;

  meta = {
    description = "A fast, full-featured Elixir LSP optimized for large codebases";
    homepage = "https://github.com/remoteoss/dexter";
    changelog = "https://github.com/remoteoss/dexter/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "dexter";
  };
})
