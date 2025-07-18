{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rotonda";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "rotonda";
    tag = "v${version}";
    hash = "sha256-DpFrJH37ysNc3hv7UrDktqRWrucAX6ZlpwUAT0PDm5k=";
  };

  passthru.updateScript = nix-update-script { };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cWPsFUa31hcNzqSSBbnhWccJqYGQbpbZNcVr0G14cqE=";

  meta = {
    description = "Rotonda - composable, programmable BGP Engine";
    homepage = "https://github.com/NLnetLabs/rotonda";
    changelog = "https://github.com/NLnetLabs/rotonda/blob/refs/tags/${src.tag}/Changelog.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "rotonda";
  };
}
