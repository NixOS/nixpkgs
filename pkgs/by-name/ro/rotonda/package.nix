{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rotonda";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "rotonda";
    tag = "v${version}";
    hash = "sha256-V/vHWscrajdjOtnfNs3tvGKC1WDNnUQlzHCEDGnjAuc=";
  };

  doCheck = false;
  # Test can't be compiled

  passthru.updateScript = nix-update-script { };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gzIoqUrlONKn0JEu/F8zEQrG8gLbFPofFWJTkOfpoAU=";

  meta = {
    description = "Rotonda - composable, programmable BGP Engine";
    homepage = "https://github.com/NLnetLabs/rotonda";
    changelog = "https://github.com/NLnetLabs/rotonda/blob/refs/tags/${src.tag}/Changelog.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "rotonda";
  };
}
