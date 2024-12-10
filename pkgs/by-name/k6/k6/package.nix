{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "k6";
  version = "0.54.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jD91JZMoxk7FmhG3F1CKbvUliNLyvlECnZQnZUA751w=";
  };

  subPackages = [ "./" ];

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/k6 version | grep ${version} > /dev/null
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd k6 \
      --bash <($out/bin/k6 completion bash) \
      --fish <($out/bin/k6 completion fish) \
      --zsh <($out/bin/k6 completion zsh)
  '';

  meta = with lib; {
    description = "Modern load testing tool, using Go and JavaScript";
    mainProgram = "k6";
    homepage = "https://k6.io/";
    changelog = "https://github.com/grafana/k6/releases/tag/v${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      offline
      bryanasdev000
      kashw2
    ];
  };
}
