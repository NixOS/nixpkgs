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
  version = "1.9.11";

  src = fetchFromGitHub {
    owner = "kubevela";
    repo = "kubevela";
    rev = "v${version}";
    hash = "sha256-u9UGV1UwZoj4eSqqMLf8BvsfTFIYagoslN5pflDKm8c=";
  };

  vendorHash = "sha256-NnUZnlvVb2VmNx4HM8lkbTNcQA3/pctkg1UVpOY8Acs=";

  ldflags = [
    "-s" "-w"
    "-X github.com/oam-dev/kubevela/version.VelaVersion=${version}"
  ];

  subPackages = [ "references/cmd/cli" ];

  CGO_ENABLED = 0;

  # Workaround for permission issue in shell completion
  HOME = "$TMPDIR";

  installPhase = ''
    runHook preInstall
    install -Dm755 "$GOPATH/bin/cli" -T $out/bin/vela
    runHook postInstall
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
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
