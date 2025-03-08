{ buildGoModule
, fetchFromGitHub
, installShellFiles
, lib
, stdenv
, testers
, kubevela
, nix-update-script
}:

buildGoModule rec {
  pname = "kubevela";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "kubevela";
    repo = "kubevela";
    rev = "v${version}";
    hash = "sha256-McQz9K0l5RVvBF9X9r/p2yzpC463Eyi7jYk1fiWO+TU=";
  };

  vendorHash = "sha256-hlNGkE3/PzRSdJyyoJdcoDPa6UUUU55z2Ql8tD5dE3I=";

  ldflags = [
    "-s" "-w"
    "-X github.com/oam-dev/kubevela/version.VelaVersion=${version}"
  ];

  subPackages = [ "references/cmd/cli" ];

  env.CGO_ENABLED = 0;

  # Workaround for permission issue in shell completion
  HOME = "$TMPDIR";

  installPhase = ''
    runHook preInstall
    install -Dm755 "$GOPATH/bin/cli" -T $out/bin/vela
    runHook postInstall
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
}
