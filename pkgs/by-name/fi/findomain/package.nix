{
  lib,
  aws-lc,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  rustfmt,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "findomain";
  version = "11.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "findomain";
    repo = "findomain";
    tag = finalAttrs.version;
    hash = "sha256-rFEBvbX/mC7D3RyYNqZs5ikqKS14ObUJbDX5bYmPsEU=";
  };

  cargoHash = "sha256-foEngHn/TAuOkkIwI258mEu23bSU4UYgEDSxNQIBPGc=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    rustfmt
  ];

  buildInputs = [
    aws-lc
    openssl
    sqlite
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  postInstall = ''
    installManPage findomain.1
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fastest and cross-platform subdomain enumerator";
    homepage = "https://github.com/Findomain/Findomain";
    changelog = "https://github.com/Findomain/Findomain/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "findomain";
  };
})
