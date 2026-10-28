{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "routinator";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "routinator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0z8vUIbWT9LF1uglz/5QNZ/RTiGN4k/OK55cB1r1wAQ=";
  };

  cargoHash = "sha256-mlY9tFNTKf25VM4hJNegc1grxtZ/iJmlNmBd5SBellc=";

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
