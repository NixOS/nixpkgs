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
  version = "0.25.0-alpha.3";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "refs/tags/v${version}";
    hash = "sha256-P9H21X/lZ8U/yfCL/rCuP9A1wnL7UuTcX7GlCuwo5ZQ=";
  };

  cargoHash = "sha256-3hiMBwr6XT4M7J5KeH9bfGYMjZqOmYDda2Iml2emYMY=";

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
