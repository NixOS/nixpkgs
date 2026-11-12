{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hgrep";
  version = "0.3.9";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "hgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xBLpEs0PvYb7sIca9yb3vhi2Bsr1BFqB0jlD+bZT2EI=";
  };

  cargoHash = "sha256-TP+PClv7FX3kRBwJ0RAKbKoTKpi7hTZgw/Z/ktFKbwQ=";

  # Upstream hardcodes `linker=aarch64-linux-gnu-gcc` for aarch64-linux, breaking native builds
  postPatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ oniguruma ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Grep with human-friendly search results";
    homepage = "https://github.com/rhysd/hgrep";
    changelog = "https://github.com/rhysd/hgrep/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ axka ];
    mainProgram = "hgrep";
  };
})
