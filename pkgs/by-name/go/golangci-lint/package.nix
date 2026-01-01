{
  # golangci-lint has historically required code changes to support new versions of
  # go so always use the latest specific go version that golangci-lint supports
  # rather than buildGoLatestModule.
  # This can be bumped when the release notes of golangci-lint detail support for
  # new version of go.
  buildGo125Module,
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:

buildGo125Module (finalAttrs: {
  pname = "golangci-lint";
<<<<<<< HEAD
  version = "2.7.2";
=======
  version = "2.6.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golangci-lint";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-8dVIWa+yFvuBz2yXcPG1cBkxltqdjlb+tmQ+AtYuicc=";
  };

  vendorHash = "sha256-MHz9VQvObHkvf62HNcPGfsskv5RJpe6g23CoXHOGUZc";
=======
    hash = "sha256-E/qubcF5AFgWicszZcGNBlRLYqk0ZpGilR1LNw7bO/c=";
  };

  vendorHash = "sha256-KuTACpyMqq3h2MXfJ3wuD+9Z803sXROLfxtZXCbX1RA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
