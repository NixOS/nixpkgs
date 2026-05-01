{
  lib,
  openssl,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "emmylua_ls";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "EmmyLuaLs";
    repo = "emmylua-analyzer-rust";
    tag = finalAttrs.version;
    hash = "sha256-Zj5nLeTH/4sVElYP+erg6bSTX8jFqF7sqiXfaMam8pE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  buildAndTestSubdir = "crates/emmylua_ls";

  cargoHash = "sha256-JNirHIKXFsiLme5oByerHjB/3lumuAr2u3pNfxh4qa0=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/emmylua_ls";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "EmmyLua Language Server";
    homepage = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust";
    changelog = "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
    mainProgram = "emmylua_ls";
  };
})
