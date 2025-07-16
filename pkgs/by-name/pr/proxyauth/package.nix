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
  version = "0.7.12";

  src = fetchFromGitHub {
    owner = "ProxyAuth";
    repo = "ProxyAuth";
    tag = finalAttrs.version;
    hash = "sha256-P0sAbcaf0jP+d8YjHlNKqf7H5iv/hEr/IQbCE7cgeiQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Yxyg82rQaMgsnWOWE+DmrCzBBpgsicL2Qj6AB+7tv44=";

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
