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
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "refs/tags/v${version}";
    hash = "sha256-MyvA1bmXJJvRI7zDOVEO1tDlxxTghU2lDTu5QiN8f08=";
  };

  cargoHash = "sha256-+jmeJQdpw3ZO5Yq+78bwkr8EnaxvdUTonaSm9ZxAnj8=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # tests expect internet connectivity to query real nameservers like 8.8.8.8
  doCheck = false;

  passthru.updateScript = nix-update-script {
    # remove when 0.25.0 is released
    extraArgs = [
      "--version"
      "unstable"
    ];
  };

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
