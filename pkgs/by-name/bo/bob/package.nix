{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  fetchpatch,
}:

buildGoModule rec {
  pname = "bob";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "benchkram";
    repo = "bob";
    tag = version;
    hash = "sha256-zmWfOLBb+GWw9v6LdCC7/WaP1Wz7UipPwqkmI1+rG8Q=";
  };

  patches = [
    # Fix vulnerable dependencies
    # Backport of https://github.com/benchkram/bob/pull/387
    (fetchpatch {
      url = "https://github.com/benchkram/bob/commit/5020e6fafbfbcb1b3add5d936886423ce882793d.patch";
      hash = "sha256-if1ZErI0Un7d26eOkYSkEa87+VTRcEtF6JbsJYOHpHE=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  vendorHash = "sha256-u0nFaTQWU9O7A/RAhGaLcBka+YNGjSlpycDF8TLQALw=";

  excludedPackages = [
    "example/server-db"
    "test/e2e"
    "tui-example"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd bob \
      --bash <($out/bin/bob completion) \
      --zsh <($out/bin/bob completion -z)
  '';

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Build system for microservices";
    mainProgram = "bob";
    homepage = "https://bob.build";
    license = licenses.asl20;
    maintainers = with maintainers; [ zuzuleinen ];
  };
}
