{
  buildGoModule,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "golangci-lint";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JMFSYT9aiBdr/lOy+GYigbpMHETTQAomGZ7ehyr8U/M=";
  };

  vendorHash = "sha256-o01naYSkPpsXSvFlphGqJR14j3IBmTGBHpsu7DUE1Xg=";

  subPackages = [ "cmd/golangci-lint" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=v${finalAttrs.version}"
    "-X main.date=19700101-00:00:00"
  ];

  postInstall =
    let
      golangcilintBin =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out"
        else
          lib.getBin buildPackages.golangci-lint;
    in
    ''
      installShellCompletion --cmd golangci-lint \
        --bash <(${golangcilintBin}/bin/golangci-lint completion bash) \
        --fish <(${golangcilintBin}/bin/golangci-lint completion fish) \
        --zsh <(${golangcilintBin}/bin/golangci-lint completion zsh)
    '';

  meta = {
    description = "Fast linters Runner for Go";
    homepage = "https://golangci-lint.run/";
    changelog = "https://github.com/golangci/golangci-lint/blob/v${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "golangci-lint";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      mic92
    ];
  };
})
