{
  lib,
  fetchFromGitLab,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cerbero";
  version = "0.0.22";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "Zer1t0";
    repo = "cerbero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S0XqULcBUAVbt1qVM7QYaVei+6jrFIZxdYSBnQjs3dc=";
  };

  cargoHash = "sha256-K9m7zSn3Fd8vfqC7ahxv0+rXUQ9G6eQ7Kfy43Uj4hOk=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kerberos protocol attacker";
    homepage = "https://gitlab.com/Zer1t0/cerbero";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cerbero";
  };
})
