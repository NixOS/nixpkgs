{
  fetchFromGitHub,
  lib,
  libpcap,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netwatch-tui";
  version = "0.29.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "netwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-evfnMhLV+qxovhmBr4bGvCnY7weBGzfw6I67VJfYKJc=";
  };

  cargoHash = "sha256-W5zNveZuHxQXFggTI+rgB68FDZEFzOcbEXS2oIVhHYY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpcap ];

  doInstallCheck = true;
  nativeCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time network diagnostics in your terminal.";
    homepage = "https://www.netwatchlabs.com/labs/netwatch";
    changelog = "https://github.com/matthart1983/netwatch/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "netwatch";
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
