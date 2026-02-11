{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bulletty";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "CrociDB";
    repo = "bulletty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J4ljTQuEWwGvxDbwBaP7z0TPqpLKQCmd4YSaIpcVYvg=";
  };

  patches = [
    # Add patch that disables rustfmt to prevent compile time crashes
    ./remove-rustfmt-exec.patch
  ];

  cargoHash = "sha256-yL7qYE60TBtEoj+0/ykhbEv6XBfk9JA0y8JLvRzaAHI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI RSS/ATOM feed reader";
    homepage = "https://bulletty.croci.dev";
    changelog = "https://github.com/CrociDB/bulletty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FKouhai ];
    mainProgram = "bulletty";
  };
})
