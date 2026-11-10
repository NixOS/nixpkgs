{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "findomain";
  version = "10.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "findomain";
    repo = "findomain";
    tag = finalAttrs.version;
    hash = "sha256-qMSVj+qhrx1LPuXWXKzo0v4yirNW2x/o/blNkSVU3Tg=";
  };

  cargoHash = "sha256-uYhCTjVzkW8menf67pnZfYCMIcNZadoGJvtDmsDDxP8=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

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
