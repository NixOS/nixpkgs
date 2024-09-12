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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "snpguest";
    rev = "refs/tags/v${version}";
    hash = "sha256-qc7WooUJQa0+tzoS0z0GPV3N3WGM1WQ4ewZj8zUWHZE=";
  };

  cargoHash = "sha256-GYLJGkEI7AYUxuE57fGz4NM9hZ+Z73tq8wnOzANtwnM=";

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
