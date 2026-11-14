{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  zstd,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fast-resume";
  version = "2.14.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "angristan";
    repo = "fast-resume";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ptLdVz27CyLZ2sebE3bnhKvIdbBbpEdr5fHqY7HNw34=";
  };

  cargoHash = "sha256-zEK3dmgzx7GO77vAZfE6WTVR43iCohpC4maMXl8uKKs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
    zstd
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # Upstream ships the binary as `fr` and provides `fast-resume` as an alias
  postInstall = ''
    ln -s fr "$out/bin/fast-resume"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find that one coding agent session you want to get back to";
    homepage = "https://github.com/angristan/fast-resume";
    changelog = "https://github.com/angristan/fast-resume/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      angristan
    ];
    mainProgram = "fr";
  };
})
