{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  libiconv,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "convco";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "convco";
    repo = "convco";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fJrP4XtlUX0RvH8T76YxqUCM/R+QvUpsaumn3Z1SOh0=";
  };

  cargoHash = "sha256-ySTXy8Jqw/EZl/olbWjMaDD8dryUFyWFvyapfvglFHI=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  checkFlags = [
    # disable test requiring networking
    "--skip=git::tests::test_find_last_unordered_prerelease"
    "--skip=git::tests::test_find_matching_prerelease"
    "--skip=git::tests::test_find_matching_prerelease_without_matching_release"
  ];

  meta = {
    description = "Conventional commit cli";
    mainProgram = "convco";
    homepage = "https://github.com/convco/convco";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      hoverbear
      cafkafk
    ];
  };
})
