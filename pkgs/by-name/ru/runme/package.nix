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

buildGoModule rec {
  pname = "runme";
  version = "3.8.3";

  src = fetchFromGitHub {
    owner = "stateful";
    repo = "runme";
    rev = "v${version}";
    hash = "sha256-AnGh1Kg3CV4UkEwZ81QMeIf9whdeCglmCbfp8DC6N30=";
  };

  vendorHash = "sha256-qOM66jiSjAU5e6eGrM8kgJxWJzxwgHpLadx5pTjNFOs=";

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
    "-X=github.com/stateful/runme/v3/internal/version.BuildDate=1970-01-01T00:00:00Z"
    "-X=github.com/stateful/runme/v3/internal/version.BuildVersion=${version}"
    "-X=github.com/stateful/runme/v3/internal/version.Commit=${src.rev}"
  ];

  # checkFlags = [
  #   "-ldflags=-X=github.com/stateful/runme/v3/internal/version.BuildVersion=${version}"
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

  meta = with lib; {
    description = "Execute commands inside your runbooks, docs, and READMEs";
    mainProgram = "runme";
    homepage = "https://runme.dev";
    changelog = "https://github.com/stateful/runme/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
