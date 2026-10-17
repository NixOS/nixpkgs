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
  version = "0.2.0";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "mytecor";
    repo = "rns-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uwDScvVMbFdrkb5k3n2OJTiVSzo8O/P08NLURffnE74=";
  };

  cargoHash = "sha256-vokQY+V+2qwrONiQIivedXZUvMLlAqRtdwzzpYNTBG4=";

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
