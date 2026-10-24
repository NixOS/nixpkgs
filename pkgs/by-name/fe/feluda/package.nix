{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  pkg-config,
  openssl,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "feluda";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "anistark";
    repo = "feluda";
    tag = finalAttrs.version;
    hash = "sha256-R8x4lN4BtVbpSHll0KVdzX7IDhArsZiJFo6qNsFrgnA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-F5flqmoH9QykmCvuqxLhsdpm3AYhwhCG4O1oRkEOY8U=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_DIR = "${lib.getDev openssl}";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  checkFlags = [
    # Require internet access.
    "--skip=licenses::tests::test_fetch_license_for_go_dependency"
    "--skip=licenses::tests::test_fetch_license_for_python_dependency"
  ];

  passthru.updateScript = nix-update-script { };
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Detect license usage restrictions in your project";
    homepage = "https://github.com/anistark/feluda";
    changelog = "https://github.com/anistark/feluda/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ adda ];
    mainProgram = "feluda";
  };
})
