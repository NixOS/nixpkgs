{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "astartectl";
  version = "26.5.0";

  src = fetchFromGitHub {
    owner = "astarte-platform";
    repo = "astartectl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mRPy5nnj/1T3tnii+Z9QmL6kZba2Wom/jGncp+ZynFg=";
  };

  vendorHash = "sha256-Yz6Ph6TqyWlEXnkW/g1DDqxaqTM9DJrnO+QJgzqjVhw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd astartectl \
      --bash <($out/bin/astartectl completion bash) \
      --fish <($out/bin/astartectl completion fish) \
      --zsh <($out/bin/astartectl completion zsh)
  '';

  meta = {
    homepage = "https://github.com/astarte-platform/astartectl";
    description = "Astarte command line client utility";
    license = lib.licenses.asl20;
    mainProgram = "astartectl";
    maintainers = with lib.maintainers; [ noaccos ];
  };
})
