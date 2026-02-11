{
  # golangci-lint has historically required code changes to support new versions of
  # go so always use the latest specific go version that golangci-lint supports
  # rather than buildGoLatestModule.
  # This can be bumped when the release notes of golangci-lint detail support for
  # new version of go.
  buildGo126Module,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGo126Module (finalAttrs: {
  pname = "golangci-lint";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8LEtm1v0slKwdLBtS41OilKJLXytSxcI9fUlZbj5Gfw=";
  };

  vendorHash = "sha256-w8JfF6n1ylrU652HEv/cYdsOdDZz9J2uRQDqxObyhkY=";

  subPackages = [ "cmd/golangci-lint" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=v${finalAttrs.version}"
    "-X main.date=1970-01-01T00:00:00Z"
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
