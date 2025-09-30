{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "k6";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "k6";
    rev = "v${version}";
    hash = "sha256-eD5MlKdC/hQbb6XdMl3stMPZkhCEKom0hfMd0qHp/ek=";
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

  meta = {
    description = "Modern load testing tool, using Go and JavaScript";
    mainProgram = "k6";
    homepage = "https://k6.io/";
    changelog = "https://github.com/grafana/k6/releases/tag/v${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      offline
      bryanasdev000
      kashw2
    ];
  };
}
