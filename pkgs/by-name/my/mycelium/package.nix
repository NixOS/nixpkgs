{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "mycelium";
  version = "0.6.1";

  sourceRoot = "${src.name}/myceliumd";

  src = fetchFromGitHub {
    owner = "threefoldtech";
    repo = "mycelium";
    rev = "v${version}";
    hash = "sha256-DP6gCTuWraCwprY5C0JlTR1VrOwrOnUMSVxuPSVMjo0=";
  };

  cargoHash = "sha256-5TyJNYBTULSu886D+vy8YRh50oFBubNZ9KkMu1/PvgU=";

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

  meta = with lib; {
    description = "End-2-end encrypted IPv6 overlay network";
    homepage = "https://github.com/threefoldtech/mycelium";
    changelog = "https://github.com/threefoldtech/mycelium/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      flokli
      matthewcroughan
      rvdp
    ];
    mainProgram = "mycelium";
  };
}
