{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  lib,
  stdenv,
  testers,
  kubevela,
  nix-update-script,
}:
let
  canGenerateShellCompletions = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
buildGoModule (finalAttrs: {
  pname = "kubevela";
  version = "1.10.6";

  src = fetchFromGitHub {
    owner = "kubevela";
    repo = "kubevela";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lY+gz/rv+UcIDFOIa7jFoYsFRSBcHSzET+LZH/HC1PM=";
  };

  vendorHash = "sha256-MUfULgycZn8hFfWmtNeoFf21+g3gGpeKoBvL8qB/m80=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/oam-dev/kubevela/version.VelaVersion=${finalAttrs.version}"
  ];

  subPackages = [ "references/cmd/cli" ];

  env.CGO_ENABLED = 0;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$GOPATH/bin/cli" -T $out/bin/vela
    runHook postInstall
  '';

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals canGenerateShellCompletions [
    writableTmpDirAsHomeHook # Workaround for permission issue in shell completion
  ];

  postInstall = lib.optionalString canGenerateShellCompletions ''
    installShellCompletion --cmd vela \
      --bash <($out/bin/vela completion bash) \
      --zsh <($out/bin/vela completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = kubevela;
    command = "HOME=$TMPDIR vela version";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Application delivery platform to deploy and operate applications in hybrid, multi-cloud environments";
    downloadPage = "https://github.com/kubevela/kubevela";
    homepage = "https://kubevela.io/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "vela";
  };
})
