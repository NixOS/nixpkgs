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
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "runmedev";
    repo = "runme";
    rev = "v${version}";
    hash = "sha256-pMYhII+1gMZnabsGi7y82ZDvmxjDJWqhhvWegbQfTC0=";
  };

  vendorHash = "sha256-qfW2k1uiOJcMRLJJ1JRACuVcCTFSkXFg/QPHTe5j+kg=";

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
    "-X=github.com/runmedev/runme/v3/internal/version.BuildVersion=${version}"
    "-X=github.com/runmedev/runme/v3/internal/version.Commit=${src.rev}"
  ];

  # checkFlags = [
  #   "-ldflags=-X=github.com/runmedev/runme/v3/internal/version.BuildVersion=${version}"
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
    changelog = "https://github.com/runmedev/runme/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
