{
  lib,
  fetchFromGitHub,
  libpcap,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ikebuster";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "myOmikron";
    repo = "ikebuster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7+i/Zzjey555M3fv7KBNsgSapehz1OUhzrTUIWmO/qM=";
  };

  buildFeatures = [ "bin" ];

  cargoHash = "sha256-hFi9CaG4xaP5bf152Be1ihubtmYLEauDkeBhoeXkkAw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpcap ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  # Cargo.lock is outdated
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scanner for IKE";
    homepage = "https://github.com/myOmikron/ikebuster";
    changelog = "https://github.com/myOmikron/ikebuster/blob/${finalAttrs.src.rev}/Changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ikebuster";
  };
})
