{ darwin
, fetchpatch
, fetchFromGitHub
, lib
, perl
, pkg-config
, openssl
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "screenly-cli";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "screenly";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-rQK1EYb1xYtcxq0Oj4eY9PCFMoaYinr42W8NkG36ps0=";
  };

  cargoPatches = [
    # This patch introduces the Cargo.lock file, which was previously missing from the repository.
    # This can be removed at the next release of the Screenly CLI. The patch was introduced in
    # this PR: https://github.com/Screenly/cli/pull/139.
    (fetchpatch {
      url = "https://github.com/Screenly/cli/commit/898bd2e5e3a9653e3c3dde17e951469885734c40.patch";
      hash = "sha256-Cqc1PHRhgS3zK19bSqpU2v+R3jSlOY6oaLJXpUy6+50=";
      includes = [ "Cargo.lock" ];
    })
  ];

  cargoHash = "sha256-TzJ56Wuk77qrxDLL17fYEj4i/YhAS6DRmjoqrzb+5AA=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = {
    description = "Tools for managing digital signs and screens at scale";
    homepage = "https://github.com/Screenly/cli";
    license = lib.licenses.mit;
    mainProgram = "screenly";
    maintainers = with lib.maintainers; [ jnsgruk vpetersson ];
  };
}
