{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  python3Packages,
  pandoc,
  shellcheck,
  nix-update-script,
  git,
  bash,
  zsh,
  fish,
}:

buildGoModule (finalAttrs: {
  pname = "actionlint";
  version = "1.16.1";

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "kjanat";
    repo = "actionlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zlBSx7zFUEmTMmCL8J0SSUGN8kQrWPlmq84BzYqsuXw=";
  };

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X actionlint.kjanat.dev.version=${finalAttrs.version}"
    "-X actionlint.kjanat.dev.installedFrom=Nix"
  ];

  vendorHash = "sha256-PVEf1pJvwQu/2dFS0YhWoXahnTqvqmRdYjVfujjs04k=";

  nativeBuildInputs = [
    makeWrapper
    pandoc
    installShellFiles
  ];

  nativeCheckInputs = [
    git
    bash
    zsh
    fish
    shellcheck
    python3Packages.pyflakes
  ];

  checkPhase = ''
    runHook preCheck
    export GOFLAGS=''${GOFLAGS//-trimpath/}
    go test ./...
    runHook postCheck
  '';

  postInstall = ''
    make man/actionlint.1 PANDOC='pandoc --standalone --from=markdown-smart ${
      if lib.versionOlder pandoc.version "3.8" then "--no-highlight" else "--syntax-highlighting=none"
    }'
    installManPage man/actionlint.1
    installShellCompletion --cmd actionlint \
      --bash <("$out/bin/actionlint" -completion bash) \
      --zsh <("$out/bin/actionlint" -completion zsh) \
      --fish <("$out/bin/actionlint" -completion fish)
    install -Dm644 actionlint.schema.json "$out/share/actionlint/actionlint.schema.json"
    wrapProgram "$out/bin/actionlint" \
      --prefix PATH : ${
        lib.makeBinPath [
          python3Packages.pyflakes
          shellcheck
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://kjanat.github.io/actionlint/";
    description = "Static checker for GitHub Actions workflow files";
    changelog = "https://github.com/kjanat/actionlint/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kjanat
      voidlily
    ];
    mainProgram = "actionlint";
  };
})
