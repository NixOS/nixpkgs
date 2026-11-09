{
  lib,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "3.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h2InUYEbQsy8Kool/91/V2ykomtDm9yL3YIAdct7U5g=";
  };

  cargoHash = "sha256-3pmaoFKW8TW19S7HSr0fvd5s0xxt05zidvL9I0hvPEU=";

  buildInputs = [ sqlite ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  env.LIBSQLITE3_SYS_USE_PKG_CONFIG = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/manic-systems/dix";
    description = "Blazingly fast tool to diff Nix related things";
    changelog = "https://github.com/manic-systems/dix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "riscv64-linux"
    ];
    maintainers = with lib.maintainers; [
      faukah
      NotAShelf
    ];
    mainProgram = "dix";
  };
})
