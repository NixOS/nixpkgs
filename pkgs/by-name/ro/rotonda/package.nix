{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rotonda";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "rotonda";
    tag = "v${version}";
    hash = "sha256-C8untp5qGLhqZYuSloxNNy6+KxfLpUGv0sfdL9jJS5M=";
  };

  passthru.updateScript = nix-update-script { };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yLKBQHPmBT8cyN/O2ohDpDpd6X1pPqN3hPVbPdyyMuQ=";

  meta = {
    description = "Rotonda - composable, programmable BGP Engine";
    homepage = "https://github.com/NLnetLabs/rotonda";
    changelog = "https://github.com/NLnetLabs/rotonda/blob/refs/tags/${src.tag}/Changelog.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "rotonda";
  };
}
