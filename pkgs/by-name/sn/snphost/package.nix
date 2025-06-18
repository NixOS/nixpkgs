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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "snphost";
    tag = "v${version}";
    hash = "sha256-sBEIQQ0vfwQh5eqsC6x37VDlbXuBUybRh4LNUjfEJ5A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-aNXv6Av3JvnTqTbxX70FmwEF4jJaQmD6FHjvh7om9iE=";

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
