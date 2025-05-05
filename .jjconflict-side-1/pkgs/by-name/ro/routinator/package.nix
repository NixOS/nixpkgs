{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-itD9d+EqEdJ2bTJEpHxJCFFS8Mpc7AFQ1JgkNQxncV0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-58EnGouq8iKkgsvyHqARoQ0u4QXjw0m6pv4Am4J9wlU=";

  meta = with lib; {
    description = "RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
    mainProgram = "routinator";
  };

  passthru.tests = {
    basic-functioniality = nixosTests.routinator;
  };
}
