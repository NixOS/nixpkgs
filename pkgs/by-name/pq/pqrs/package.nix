{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pqrs";
  version = "0.3.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "pqrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0oSSoGZga0OGAKUNsLmKkUl8N1l0pVi4KIqrKJbeVVU=";
  };

  cargoHash = "sha256-P3yTmECj0K0mjWUiWlQCwuQVbnbVR1xFV5cE8Uo3U90=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "CLI tool to inspect Parquet files";
    mainProgram = "pqrs";
    homepage = "https://github.com/manojkarthick/pqrs";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = [ lib.maintainers.manojkarthick ];
  };
})
