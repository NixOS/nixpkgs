{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

let
  version = "0.5.0";
in
rustPlatform.buildRustPackage {
  pname = "socks-to-http-proxy";
  inherit version;

  src = fetchFromGitHub {
    owner = "KaranGauswami";
    repo = "socks-to-http-proxy";
    tag = "v${version}";
    hash = "sha256-adtrGMkYueplW6rJ+pK+6+LaMU++YeV48m2Ntliqsy4=";
  };

  cargoHash = "sha256-jR0uX/edFby9OYCF0HVkRDT3fiz4bI3yGr8Yc3IlnRM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false; # Skip network tests

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Converts SOCKS5 proxy into HTTP proxy";
    homepage = "https://github.com/KaranGauswami/socks-to-http-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mksafavi ];
    mainProgram = "sthp";
  };
}
