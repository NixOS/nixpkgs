{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustfinity";
  version = "0.4.9";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-0xEVYHvVOugfE4mQxYt+U7AsejOxm/SnDV8HsmcZxBs=";
  };

  cargoHash = "sha256-Zc3m+hTotgCqBguUB/KM4BtGsdD4W5MR/ZBg2X/0nNk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = 1;

  # Fail to run in sandbox environment
  checkFlags = map (t: "--skip=${t}") [
    "challenge::tests::test_challenge_exists"
    "crates_io::tests::test_get_latest_version"
    "dir::tests::test_get_current_dir"
    "download::tests::download_file::test_downloads_file"
    "download::tests::download_file::test_renames_starter"
  ];

  meta = {
    description = "CLI for Rustfinity challenges solving";
    homepage = "https://github.com/rustfinity/rustfinity/tree/main/crates/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "rustfinity";
  };
})
