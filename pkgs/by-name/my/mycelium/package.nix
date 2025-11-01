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
  version = "0.6.2";

  sourceRoot = "${src.name}/myceliumd";

  src = fetchFromGitHub {
    owner = "threefoldtech";
    repo = "mycelium";
    rev = "v${version}";
    hash = "sha256-KGMbc/DgBUY3yiDsMbafCVukSX8M/HATBBOYxMxgCBY=";
  };

  cargoHash = "sha256-FknFH2k7EhQBEI3xBy+iYYkzkVSdfyUJ26m6sPFxTWM=";

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
