{
  lib,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adhammer";
  version = "1.3.10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "icedracon";
    repo = "adhammer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QQjiyvj3e5unEsh17UyKck2rs8oKeLO5eodBG7cn1LQ=";
  };

  cargoHash = "sha256-Ebkvxl/JyiZ84ucv7FmOluHTqYd14I3B6z53QNmVQZw=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Active Directory security-assessment toolkit";
    homepage = "https://github.com/icedracon/adhammer";
    changelog = "https://github.com/icedracon/adhammer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "adhammer";
  };
})
