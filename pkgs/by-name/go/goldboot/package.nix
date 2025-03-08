{
  fetchFromGitHub,
  rustPlatform,
  pkgs,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "goldboot";
  version = "0.0.10";

  meta = with lib; {
    mainProgram = "goldboot";
    description = "Immutable infrastructure for the desktop!";
    homepage = "https://github.com/fossable/goldboot";
    license = licenses.agpl3Plus;
    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ cilki ];
  };
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [
    zstd
    OVMF
    qemu
    qemu-utils
    openssl
  ];

  src = fetchFromGitHub {
    owner = "fossable";
    repo = "goldboot";
    rev = "goldboot-${version}";
    hash = "sha256-O9yhyJZpjQxC0HP43RsOgPMOKp6d23SNhMLiGtmwXzs=";
  };

  doCheck = false;
  buildAndTestSubdir = "goldboot";

  useFetchCargoVendor = true;
  cargoHash = "sha256-NF0Fj+r6qWcM4VEIm1fzveZuz6MIaG32Z+zBfSMC/t4=";
}
