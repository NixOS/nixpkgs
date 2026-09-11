{
  lib,
  fetchFromForgejo,
  rustPlatform,
  pkg-config,
  openssl,
  nettle,
  libmysqlclient,
  libpq,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proxyauth";
  version = "1.2.0";

  src = fetchFromForgejo {
    domain = "git.proxyauth.app";
    owner = "ProxyAuth";
    repo = "ProxyAuth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Im6BfBhzxrcbaZ0rvy0+dQ4Dx8L2NQz7zMc1SOY6xnY=";
  };

  cargoHash = "sha256-q7goMwGtcBnnYXqhylmygQFTEGzTQG6IbgUhuKRiw+8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    nettle
    libmysqlclient
    libpq
  ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeCheckInputs = [
    cacert
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Edge reverse proxy for OIDC/API authentication and dashboards";
    homepage = "https://git.proxyauth.app/ProxyAuth/ProxyAuth";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "proxyauth";
  };
})
