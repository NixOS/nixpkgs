{
  lib,
  stdenv,
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
  version = "0.7.11";

  src = fetchFromGitHub {
    owner = "ProxyAuth";
    repo = "ProxyAuth";
    tag = finalAttrs.version;
    hash = "sha256-7VIcRsWDV8wYfK3kGivtqHyyyOlbKelT9yazh5MNYQA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3+S5o/11fD1bXT0QzD0f+SsfWO0x3UOYZrmGl0B+mWc=";

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
  doInstallCheck = false;

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
