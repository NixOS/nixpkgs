{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  openssl,
  zlib,
  asciidoctor,
  nix-update-script,
  findutils,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "snphost";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "snphost";
    rev = "v${version}";
    hash = "sha256-ChB745I+4CuN/qvWW5e5gPWBdTDJdrUMiHO3LkmTwtk=";
  };

  cargoHash = "sha256-yXjrTxCRI+1IMRmBYLw9+uHr9BVVhRXx6zU2q3sYf9s=";

  nativeBuildInputs = [
    asciidoctor
    findutils
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    curl
    openssl
    zlib
  ];

  # man page is placed in cargo's $OUT_DIR, which is randomized.
  # Contacted upstream about it, for now use find to locate it.
  postInstall = ''
    installManPage $(find target/x86_64-unknown-linux-gnu/release/build -name "snphost.1")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Administrative utility for SEV-SNP";
    homepage = "https://github.com/virtee/snphost/";
    changelog = "https://github.com/virtee/snphost/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "snphost";
    platforms = [ "x86_64-linux" ];
  };
}
