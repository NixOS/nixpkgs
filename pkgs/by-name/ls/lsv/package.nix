{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "lsv";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "SecretDeveloper";
    repo = "lsv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q8UCjGY1h0r61+xp8jGwDUHF/M/7lWZNw6iwZMjTiPE=";
  };

  cargoHash = "sha256-o2LLUTijzCqlyoKrO+Fv6m7DneTnm+BnA8Q943Oo37E=";
  env.RUSTC_BOOTSTRAP = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Configurable command line file browser with preview and key bindings";
    homepage = "https://github.com/SecretDeveloper/lsv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Inarizxc ];
    platforms = lib.platforms.linux;
    mainProgram = "lsv";
  };
})
