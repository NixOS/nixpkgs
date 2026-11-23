{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "miller";
  version = "6.23.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zBEh71/2I8t1NQadyR/hYdCItNMLdHSLOr6rCIFYn0A=";
  };

  outputs = [
    "out"
    "man"
  ];

  vendorHash = "sha256-0QpTunOoNVgiPI4lh0smkmPBv3owCPShRETxivsk274=";

  subPackages = [ "cmd/mlr" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/mlr.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion \
      --cmd mlr \
      --bash <($out/bin/mlr completion bash) \
      --zsh <($out/bin/mlr completion zsh)
  '';

  meta = {
    changelog = "https://github.com/johnkerl/miller/releases/tag/${finalAttrs.src.tag}";
    description = "Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed";
    homepage = "https://miller.readthedocs.io/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mstarzyk ];
    mainProgram = "mlr";
    platforms = lib.platforms.all;
  };
})
