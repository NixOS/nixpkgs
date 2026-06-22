{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "routinator";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "routinator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y/L9l++uB627lEHK+mASNwLohqWk+R0FUNYMKKNg38A=";
  };

  cargoHash = "sha256-rDFwfRXd8oMNh8iOPEWM1eADFQjys0GwPVr2r5hLW4Y=";

  meta = {
    description = "RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${finalAttrs.version}/Changelog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "routinator";
  };

  passthru.tests = {
    basic-functioniality = nixosTests.routinator;
  };
})
