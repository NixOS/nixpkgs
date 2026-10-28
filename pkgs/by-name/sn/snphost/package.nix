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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snphost";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "snphost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DDAAfQOKPsbCfNoen3VZDGCDz23plnRZZLKGSNSynNg=";
  };

  cargoHash = "sha256-zK1gLueNIo9KcABdn/nxMf5vjFHfaqRAG2MfTkYSVI4=";

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
    changelog = "https://github.com/virtee/snphost/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      katexochen
      charludo
    ];
    mainProgram = "snphost";
    platforms = [ "x86_64-linux" ];
  };
})
