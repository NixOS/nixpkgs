{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-play";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "fanzeyi";
    repo = "cargo-play";
    tag = finalAttrs.version;
    sha256 = "sha256-Z5zcLQYfQeGybsnt2U+4Z+peRHxNPbDriPMKWhJ+PeA=";
  };

  cargoHash = "sha256-kgdg2GZmFGMua3eYo30tpDTFBKncbaiONJf+ocfMaBk=";

  # these tests require internet access
  checkFlags = [
    "--skip=dtoa_test"
    "--skip=infer_override"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Run your rust code without setting up cargo";
    mainProgram = "cargo-play";
    homepage = "https://github.com/fanzeyi/cargo-play";
    changelog = "https://github.com/fanzeyi/cargo-play/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
