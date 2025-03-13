{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cobalt";
  version = "0.19.8";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-neOJ3UqRisCcyarRIXfHyl9nAe2Wl9IXVDNwIYEQYys=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-j2xmEoMV7lVhqj4lKWA3QdEDEGUpRlZc4ikZoDQJlB8=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Static site generator written in Rust";
    homepage = "https://cobalt-org.github.io/";
    downloadPage = "https://github.com/cobalt-org/cobalt.rs/";
    changelog = "https://github.com/cobalt-org/cobalt.rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.unix;
    mainProgram = "cobalt";
  };
})
