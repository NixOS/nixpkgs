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
  version = "0.24.4";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    tag = "v${version}";
    hash = "sha256-lfYo3YFgFoKM+ailq5ljSZ3NC+wRpjropaJ/rDRhajA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1S3tGvNYF//ztPdPENP8i1mCXY+UN7b904cq8WP/Anw=";

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
