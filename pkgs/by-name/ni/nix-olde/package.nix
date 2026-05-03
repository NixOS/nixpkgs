{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-olde";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "nix-olde";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q5M9/tW5Kz4ILm0MKhx540iPrFaH5Y5gQawZ13l2hg0=";
  };

  cargoHash = "sha256-jCaDTLF3U3Ov1EBsoz27UlA2KYXnDTD9GRcj0isueNQ=";

  meta = {
    description = "Show details about outdated packages in your NixOS system";
    homepage = "https://github.com/trofi/nix-olde";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qweered ];
    mainProgram = "nix-olde";
  };
})
