{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "kargo";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "akuity";
    repo = "kargo";
    rev = "v${version}";
    hash = "sha256-GC3u4v8qrVi8+Ne08f074DvPh0RFmpmCOdJ5XD3kk+o=";
  };

  vendorHash = "sha256-Xb+9zu2uivOYETtz3ryMnBUJ3gJ/1ta1dLEpsD00jpU=";

  subPackages = [ "cmd/cli" ];

  ldflags =
    let
      package_url = "github.com/akuity/kargo/internal/version";
    in
    [
      "-s"
      "-w"
      "-X ${package_url}.version=${src.rev}"
      "-X ${package_url}.buildDate=1970-01-01T00:00:00Z"
      "-X ${package_url}.gitCommit=${src.rev}"
      "-X ${package_url}.gitTreeState=clean"
    ];

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 "$GOPATH/bin/cli" -T $out/bin/kargo
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME="$(mktemp -d)"
    $out/bin/kargo version --client | grep ${src.rev} > /dev/null
    runHook postInstallCheck
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME="$(mktemp -d)"
    installShellCompletion --cmd kargo \
      --bash <($out/bin/kargo completion bash) \
      --fish <($out/bin/kargo completion fish) \
      --zsh <($out/bin/kargo completion zsh)
  '';

  meta = with lib; {
    description = "Application lifecycle orchestration";
    mainProgram = "kargo";
    downloadPage = "https://github.com/akuity/kargo";
    homepage = "https://kargo.akuity.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
      bbigras
    ];
  };
}
