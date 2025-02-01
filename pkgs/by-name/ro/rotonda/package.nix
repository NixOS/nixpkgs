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

  cargoHash = "sha256-/9ge2FcCc1t2MP32juMa7yHyeOqhk9e5b5LEgjKryYc=";

  meta = {
    description = "Rotonda - composable, programmable BGP Engine";
    homepage = "https://github.com/NLnetLabs/rotonda";
    changelog = "https://github.com/NLnetLabs/rotonda/blob/refs/tags/${src.tag}/Changelog.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "rotonda";
  };
}
