{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "astartectl";
  version = "24.5.3";

  src = fetchFromGitHub {
    owner = "astarte-platform";
    repo = "astartectl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wziSP4mbUnAAPzmkl1qXbT95Ku/M9rMb63s/5ndCXrk=";
  };

  vendorHash = "sha256-TZ0ua64DPVlGBrr4ZCexBoyuwvJzRr1t37BTJ2bLuQI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd astartectl \
      --bash <($out/bin/astartectl completion bash) \
      --fish <($out/bin/astartectl completion fish) \
      --zsh <($out/bin/astartectl completion zsh)
  '';

  meta = {
    homepage = "https://github.com/astarte-platform/astartectl";
    description = "Astarte command line client utility";
    license = lib.licenses.asl20;
    mainProgram = "astartectl";
    maintainers = with lib.maintainers; [ noaccos ];
  };
})
