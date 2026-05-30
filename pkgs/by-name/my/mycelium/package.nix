{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mycelium";
  version = "0.7.9";

  sourceRoot = "${finalAttrs.src.name}/myceliumd";

  src = fetchFromGitHub {
    owner = "threefoldtech";
    repo = "mycelium";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YQq8lW+F/c92884XqUOw1XeNK6bL1EEkSyNJzj0OKLo=";
  };

  cargoHash = "sha256-Ctg5c88i/fn5AJNoAaEJ90HaKooAAQgflrA0mbHAaDU=";

  nativeBuildInputs = [ versionCheckHook ];

  doInstallCheck = true;

  env = {
    OPENSSL_NO_VENDOR = 1;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_DIR = "${lib.getDev openssl}";
  };

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) mycelium;
    };
  };

  meta = {
    description = "End-2-end encrypted IPv6 overlay network";
    homepage = "https://github.com/threefoldtech/mycelium";
    changelog = "https://github.com/threefoldtech/mycelium/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      flokli
      matthewcroughan
      rvdp
    ];
    mainProgram = "mycelium";
  };
})
