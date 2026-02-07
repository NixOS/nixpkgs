{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gzip,
  makeBinaryWrapper,
  pkg-config,
  openssl,
  gitMinimal,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fresh";
  version = "0.1.99";

  src = fetchFromGitHub {
    owner = "sinelaw";
    repo = "fresh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E0W4f6J20OGa0jqvhMfBb+cO/RQ66C5yx0Ln+faKYc4=";
  };

  cargoHash = "sha256-NbbT7CX1OS/OFbC9KC9NBAwh85so3jhGinc7+qgUtBs=";

  nativeBuildInputs = [
    gzip
    makeBinaryWrapper
    pkg-config
  ];

  nativeCheckInputs = [
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
      --add-flags "--no-upgrade-check"
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
      binaryNativeCode # librusty_v8.a
    ];
  };
})
