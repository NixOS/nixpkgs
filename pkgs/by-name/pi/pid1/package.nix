{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pid1";
  version = "0.1.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fpco";
    repo = "pid1-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-edxDCVEVg4s2RF3wjiUjQ4wfusFM3COUTl5nsCH4ScE=";
  };

  cargoHash = "sha256-mXZszLmIOEq3ZL6cJhrhBCi0bHNgbKG6gr6Rf4iFvEM=";

  # all tests require docker env
  doCheck = false;

  meta = {
    description = "Signal handling and zombie reaping for PID1 process";
    homepage = "https://github.com/fpco/pid1-rs";
    changelog = "https://github.com/fpco/pid1-rs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psibi ];
    mainProgram = "pid1";
  };
})
