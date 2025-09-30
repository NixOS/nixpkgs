{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "routinator";
    rev = "v${version}";
    hash = "sha256-RR02+fcrSXLcX4Un7Yd7iNXYHKo0lFHsWt9u+n5DKWg=";
  };

  cargoHash = "sha256-faXn3yzFi3prPVk9Oc1detKEcNUiSBDsAJZP5paPEdI=";

  meta = {
    description = "RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "routinator";
  };

  passthru.tests = {
    basic-functioniality = nixosTests.routinator;
  };
}
