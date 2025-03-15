{
  fetchFromGitHub,
  rustPlatform,
  pkgs,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "goldboot";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "fossable";
    repo = "goldboot";
    rev = "goldboot-v${version}";
    hash = "sha256-O9yhyJZpjQxC0HP43RsOgPMOKp6d23SNhMLiGtmwXzs=";
  };

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [
    zstd
    OVMF
    qemu
    qemu-utils
    openssl
  ];

  # Tests require networking, so skip them for now
  doCheck = false;
  buildAndTestSubdir = "goldboot";

  useFetchCargoVendor = true;
  cargoHash = "sha256-NF0Fj+r6qWcM4VEIm1fzveZuz6MIaG32Z+zBfSMC/t4=";

  meta = {
    mainProgram = "goldboot";
    description = "Immutable infrastructure for the desktop!";
    homepage = "https://github.com/fossable/goldboot";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
}
