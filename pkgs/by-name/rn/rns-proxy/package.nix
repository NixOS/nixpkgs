{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rns-proxy";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mytecor";
    repo = "rns-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+nn6BjzG/SJr8plAVj3R9c459XqvbKSGSqAnNa+QGkY=";
  };

  cargoHash = "sha256-o+tMlsTuFR89lNwSl3+s+WOTVVReGCJc1xAAwK1zklg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/mytecor/rns-proxy/releases/tag/${finalAttrs.src.tag}";
    description = "SOCKS5 tunnels over the Reticulum Network Stack";
    homepage = "https://github.com/mytecor/rns-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rns-proxy";
  };
})
