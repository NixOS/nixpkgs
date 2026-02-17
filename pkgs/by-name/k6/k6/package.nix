{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "k6";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "k6";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rfurCWplI21vEYEArxp4wrAn6oOWenMkGetFDy5WCAY=";
  };

  subPackages = [ "./" ];

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/k6 version | grep ${finalAttrs.version} > /dev/null
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
    changelog = "https://github.com/grafana/k6/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
})
