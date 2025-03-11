{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rotonda";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "rotonda";
    tag = "v${version}";
    hash = "sha256-iLHOt7eVCgtYwSiqpgrp8kjfi90Mz0+X2n+P6bJDWbw=";
  };

  doCheck = false;
  # Test can't be compiled

  passthru.updateScript = nix-update-script { };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fp4HhJs/x4w/FML0odbF17y7dlGfc+Ug/fkeC2s0fyk=";

  meta = {
    description = "Rotonda - composable, programmable BGP Engine";
    homepage = "https://github.com/NLnetLabs/rotonda";
    changelog = "https://github.com/NLnetLabs/rotonda/blob/refs/tags/${src.tag}/Changelog.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "rotonda";
  };
}
