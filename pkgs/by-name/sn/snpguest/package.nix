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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "snpguest";
    rev = "refs/tags/v${version}";
    hash = "sha256-otsgMUdDp93J/ynquHDs6+oLh0CunyfqZwmcKXcXX0Q=";
  };

  cargoHash = "sha256-n3gqw4R8NZP8l2PmHWag+cBXlLx1GQPPADBmaYRTe6Q=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

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
