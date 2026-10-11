{
  rustPlatform,
  fetchFromGitHub,
  lib,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {

  pname = "bkt";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "dimo414";
    repo = "bkt";
    tag = finalAttrs.version;
    hash = "sha256-qb7uRvCAXCayDIg8yQfF/Yxe0pNvR3giCQYmMIur2rM=";
  };

  cargoHash = "sha256-locf3k0jIT9RNQS9yCUtOpj4oKo5pOBU3CEYAJDbaPU=";

  checkFlags = [
    # Requires the use of "sudo" cmd which nix sandbox does not have
    "--skip=cli::cache_dirs_multi_user"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Subprocess caching utility";
    homepage = "https://github.com/dimo414/bkt";
    changelog = "https://github.com/dimo414/bkt/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "bkt";
  };
})
