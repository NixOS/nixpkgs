{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nettle,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proxyauth";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ProxyAuth";
    repo = "ProxyAuth";
    tag = finalAttrs.version;
    hash = "sha256-cVjD91tBCGyslLsYUSP1Gy7KuMQZDVxQXU7fQkWeWyM=";
  };

  cargoHash = "sha256-YhFOh60D014Tb/Gi3u+tpmXbaaIFIB5HU4X8rhWPV40=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    nettle
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Proxy Authentication Token - Fast authentication gateway for backend APIs";
    homepage = "https://github.com/ProxyAuth/ProxyAuth";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "proxyauth";
  };
})
