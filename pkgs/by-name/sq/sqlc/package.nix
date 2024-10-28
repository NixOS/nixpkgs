{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  sqlc,
}:

let
  version = "1.27.0";
in
buildGoModule {
  pname = "sqlc";
  inherit version;

  src = fetchFromGitHub {
    owner = "sqlc-dev";
    repo = "sqlc";
    rev = "v${version}";
    hash = "sha256-wxQ+YPsDX0Z6B8whlQ/IaT2dRqapPL8kOuFEc6As1rU=";
  };

  proxyVendor = true;
  vendorHash = "sha256-ndOw3uShF5TngpxYNumoK3H3R9v4crfi5V3ZCoSqW90=";

  subPackages = [ "cmd/sqlc" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sqlc \
      --bash <($out/bin/sqlc completion bash) \
      --fish <($out/bin/sqlc completion fish) \
      --zsh <($out/bin/sqlc completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = sqlc;
    command = "sqlc version";
    version = "v${version}";
  };

  meta = {
    description = "Generate type-safe code from SQL";
    homepage = "https://sqlc.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "sqlc";
  };
}
