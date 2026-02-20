{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nodejs,
  python3,
  runtimeShell,
  stdenv,
  testers,
  runme,
}:

buildGoModule (finalAttrs: {
  pname = "runme";
  version = "3.16.5";

  src = fetchFromGitHub {
    owner = "runmedev";
    repo = "runme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FtZSwD9kGFaE43iJcei2K4tzPzXku9R9OnEeub/jYlg=";
  };

  vendorHash = "sha256-5x8KEd0foUZ68dS+SeXvaDzfwHVKuKTKCxlhXivTsB0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    nodejs
    python3
  ];

  subPackages = [
    "."
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/runmedev/runme/v3/internal/version.BuildDate=1970-01-01T00:00:00Z"
    "-X=github.com/runmedev/runme/v3/internal/version.BuildVersion=${finalAttrs.version}"
    "-X=github.com/runmedev/runme/v3/internal/version.Commit=${finalAttrs.src.rev}"
  ];

  # checkFlags = [
  #   "-ldflags=-X=github.com/runmedev/runme/v3/internal/version.BuildVersion=${finalAttrs.version}"
  # ];

  # tests fail to access /etc/bashrc on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  postPatch = ''
    substituteInPlace testdata/{flags/fmt,prompts/basic,runall/basic,script/basic,tags/categories}.txtar \
      --replace-fail /bin/bash "${runtimeShell}"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd runme \
      --bash <($out/bin/runme completion bash) \
      --fish <($out/bin/runme completion fish) \
      --zsh <($out/bin/runme completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = runme;
    };
  };

  meta = {
    description = "Execute commands inside your runbooks, docs, and READMEs";
    mainProgram = "runme";
    homepage = "https://runme.dev";
    changelog = "https://github.com/runmedev/runme/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _7karni ];
  };
})
