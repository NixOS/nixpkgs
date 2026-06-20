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
  version = "0.25.7";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "netwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4QaUuKBnp3ygb5M+D/V2mhkZFRkEgWHRIxAlqEcvjwo=";
  };

  cargoHash = "sha256-S9iwtRNgVaWHC/OGxlxsUR4+oOeFhCgUaUvjNeig8Do=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpcap ];

  doInstallCheck = true;
  nativeCheckInputs = [ versionCheckHook ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time network diagnostics in your terminal.";
    homepage = "https://github.com/matthart1983/netwatch";
    changelog = "https://github.com/matthart1983/netwatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "netwatch";
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
