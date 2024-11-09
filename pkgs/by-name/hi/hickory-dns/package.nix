{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "hickory-dns";
  version = "0.25.0-alpha.2";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "refs/tags/v${version}";
    hash = "sha256-bEVApMM6/I3nF1lyRhd+7YtZuSAwiozRkMorRLhLOBY=";
  };

  cargoHash = "sha256-Rq4l1iV70nlhBaJ02hc+dmNZ/Q7qrHoF0Kp0MTmu22A=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # tests expect internet connectivity to query real nameservers like 8.8.8.8
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust based DNS client, server, and resolver";
    homepage = "https://hickory-dns.org/";
    maintainers = with lib.maintainers; [ colinsane ];
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "hickory-dns";
  };
}
