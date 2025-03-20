{
  lib,
  gitMinimal,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "mani";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "alajmo";
    repo = "mani";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-LxW9LPK4cXIXhBWPhOYWLeV5PIf+o710SWX8JVpZhPI=";
  };

  vendorHash = "sha256-8ckflry+KsEu+QgqjocXg6yyfS9R7fCfCMXwUqUSlhE=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-X github.com/alajmo/mani/cmd.version=${finalAttrs.version}"
  ];

  postInstall = ''
    installShellCompletion --cmd mani \
      --bash <($out/bin/mani completion bash) \
      --fish <($out/bin/mani completion fish) \
      --zsh <($out/bin/mani completion zsh)

    wrapProgram $out/bin/mani \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  # Skip tests
  # The repo's test folder has a README.md with detailed information. I don't
  # know how to wrap the dependencies for these integration tests so skip for now.
  doCheck = false;

  meta = {
    changelog = "https://github.com/alajmo/mani/releases/tag/v${finalAttrs.version}";
    description = "CLI tool to help you manage multiple repositories";
    homepage = "https://manicli.com";
    license = lib.licenses.mit;
    mainProgram = "mani";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
