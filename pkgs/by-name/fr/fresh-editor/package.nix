{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  gzip,
  gitMinimal,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fresh";
  version = "0.1.86";

  src = fetchFromGitHub {
    owner = "sinelaw";
    repo = "fresh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o67oowSU1V9Cy2RvLEaZ5J3CPX2kD7qByDOc+8gpDq8=";
  };

  cargoHash = "sha256-I78sdf/p5TZZufMZF8rETRb91veklwNHHByHF1WbLgk=";

  nativeBuildInputs = [
    pkg-config
    gzip
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
