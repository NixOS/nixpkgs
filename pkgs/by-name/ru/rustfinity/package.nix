{
  lib,
  stdenv,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "rustfinity";
  version = "0.2.14";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Oh+AEgmBhlOQaCFECheuHCXT6hndpUnZH/l+tWMp2RQ=";
  };

  cargoHash = "sha256-e1RnPqfgeyeEh8Av81RTuaMgYc6zoBZcygbc29DNKqE=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  OPENSSL_NO_VENDOR = 1;

  # Requires network and fs access
  checkFlags = [
    "--skip=challenge::tests::test_challenge_exists"
    "--skip=crates_io::tests::test_get_latest_version"
    "--skip=dir::tests::test_get_current_dir"
    "--skip=download::tests::download_file::test_downloads_file"
    "--skip=download::tests::download_file::test_renames_starter"
  ];

  meta = {
    description = "CLI for Rustfinity challenges solving";
    homepage = "https://github.com/dcodesdev/rustfinity.com/tree/main/crates/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "rustfinity";
  };
}
