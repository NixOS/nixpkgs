{
  lib,
  aws-lc,
  fetchFromGitHub,
  oniguruma,
  pkg-config,
  rustPackages_1_100,
  sqlite,
  stdenv,
  versionCheckHook,
}:

rustPackages_1_100.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dimcode";
  version = "0.1.0-alpha.29";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "arcships";
    repo = "dim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m3hZtCiVtgdNizARdV/gEvXNaAEYE3oJuG9Z2zUbhYo=";
  };

  cargoHash = "sha256-XA4akD1m1lPTjyQaprAPzzp4WRkX9/BSk/uANZaRDHY=";
  cargoBuildFlags = [
    "-p"
    "dimcode"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    aws-lc
    oniguruma
    sqlite
  ];

  doCheck = false;
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeInstallCheckInputs = [ versionCheckHook ];

  postInstall = ''
    install -Dm644 LICENSE "$out/share/licenses/dimcode/LICENSE"
    install -Dm644 NOTICE "$out/share/licenses/dimcode/NOTICE"
    install -Dm644 vendor/grok-build/LICENSE "$out/share/licenses/dimcode/grok-build/LICENSE"
    install -Dm644 vendor/grok-build/NOTICE "$out/share/licenses/dimcode/grok-build/NOTICE"
    install -Dm644 vendor/grok-build/xai-ratatui-inline/NOTICE "$out/share/licenses/dimcode/grok-build/xai-ratatui-inline/NOTICE"
    install -Dm644 vendor/grok-build/xai-ratatui-textarea/NOTICE "$out/share/licenses/dimcode/grok-build/xai-ratatui-textarea/NOTICE"
  '';

  meta = {
    description = "Extensible coding agent and app server";
    homepage = "https://github.com/arcships/dim";
    changelog = "https://github.com/arcships/dim/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "dimcode";
    maintainers = [ lib.maintainers.zjywill ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
})
