{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "snpguest";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "snpguest";
    tag = "v${version}";
    hash = "sha256-bUdJUWeXi+TKQVW3xSRpLhf2BfXZWPz9Rwddob1nCK0=";
  };

  cargoHash = "sha256-RGlYY6f7csrCIYxj0Nfejn0lCXEgGd/MD442H3Q3OZ0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for interacting with SEV-SNP guest environment";
    homepage = "https://github.com/virtee/snpguest";
    changelog = "https://github.com/virtee/snpguest/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "snpguest";
    platforms = [ "x86_64-linux" ];
  };
}
