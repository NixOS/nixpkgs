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
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "snphost";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "snphost";
    tag = "v${version}";
    hash = "sha256-FvHawwoIqCiZ+Jm1itDWspaI+vDN6xDfeI11KoiO/DU=";
  };

  cargoHash = "sha256-ZOXOfFYingTBq5LfJqHRf6ZdvrdY1Zve/ZMnAE25kPM=";

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

  env.OPENSSL_NO_VENDOR = true;

  # man page is placed in cargo's $OUT_DIR, which is randomized.
  # Contacted upstream about it, for now use find to locate it.
  postInstall = ''
    installManPage $(find target/x86_64-unknown-linux-gnu/release/build -name "snphost.1")
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
