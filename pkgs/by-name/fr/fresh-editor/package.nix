{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gzip,
  makeBinaryWrapper,
  pkg-config,
  openssl,
  gitMinimal,
  python3,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fresh";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "sinelaw";
    repo = "fresh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ycB5wEDYlyTDdIk5lE26c2YFMmDGGqcMuSqwqDSyxs0=";
  };

  cargoHash = "sha256-HWuHKn+vJC3cdS6bKp5iw9VSTRHn/Q5Zsj6OHvmfYp0=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    gzip
    makeBinaryWrapper
    pkg-config
  ];

  nativeCheckInputs = [
    python3
    gitMinimal
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];

  preBuild = ''
    mkdir -p $out/share/fresh-editor/plugins/
  '';

  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags "--no-upgrade-check" \
      --prefix PATH : ${lib.makeBinPath [ python3 ]}
    rm -rf $out/bin/fresh.dSYM
  '';

  # Tests create a local http server to check update functionality
  __darwinAllowLocalNetworking = true;

  # Due to issues with incorrect import paths with the actual app, I have disabled the checks below. Need to report upstream.
  checkFlags = [
    "--skip=e2e::"
    "--skip=services::plugins::embedded::tests::test_extract_plugins"
  ];
  cargoTestFlags = [
    "--lib"
    "--bins"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based text editor with LSP support and TypeScript plugins";
    homepage = "https://github.com/sinelaw/fresh";
    changelog = "https://github.com/sinelaw/fresh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      chillcicada
      dwt
      randoneering
    ];
    mainProgram = "fresh";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
})
