{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  gzip,
  gitMinimal,
  deno,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fresh";
  version = "0.1.87";

  src = fetchFromGitHub {
    owner = "sinelaw";
    repo = "fresh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-th4wlkGP9WNdRRhJy3pBC5dcqRbkUooM65FoftQHqBE=";
  };

  cargoHash = "sha256-6b4iDXJme3uanEfz/e4jI1kqljaH8iOqS+7p1MPwhY4=";

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

  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  env.RUSTY_V8_ARCHIVE = deno.librusty_v8;

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
