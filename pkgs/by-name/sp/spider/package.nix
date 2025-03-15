{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spider";
  version = "2.33.11";

  src = fetchFromGitHub {
    owner = "spider-rs";
    repo = "spider";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wrtkBqq1wJWg+0K4+PILPdMQe1AFOhJ1dJHvwq2irQo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QxfnpiGHYYk8v0rR/eE6KHW1KdZQGuJPz1jGwtl27rs=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Web crawler and scraper for Rust";
    homepage = "https://github.com/spider-rs/spider";
    changelog = "https://github.com/spider-rs/spider/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      pwnwriter
    ];
    mainProgram = "spider";
  };
})
