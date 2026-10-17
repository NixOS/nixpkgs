{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "openfga";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "openfga";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FyaufC0W9OW5d3zRcLWVjRICmo8bF7rjQNYrVWoFE64=";
  };

  vendorHash = "sha256-s1+6wdM5GQl0QcXQx0z3FUS0dx7ELHdUl86jpddiD3o=";

  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  ldflags =
    let
      buildInfoPkg = "github.com/openfga/openfga/internal/build";
    in
    [
      "-s"
      "-w"
      "-X ${buildInfoPkg}.Version=${finalAttrs.version}"
      "-X ${buildInfoPkg}.Commit=${finalAttrs.version}"
      "-X ${buildInfoPkg}.Date=19700101"
    ];

  # Tests depend on docker
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd openfga \
      --bash <($out/bin/openfga completion bash) \
      --fish <($out/bin/openfga completion fish) \
      --zsh <($out/bin/openfga completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High performance and flexible authorization/permission engine built for developers and inspired by Google Zanzibar";
    changelog = "https://github.com/openfga/openfga/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://openfga.dev/";
    license = lib.licenses.asl20;
    mainProgram = "openfga";
    maintainers = with lib.maintainers; [
      jlesquembre
      anish
    ];
  };
})
