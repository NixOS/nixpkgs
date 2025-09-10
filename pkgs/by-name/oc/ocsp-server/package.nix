{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  perl,
  libmysqlclient,
  sqlite,
  mariadb,
  postgresql,
  mbedtls,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ocsp-server";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "DorianCoding";
    repo = "OCSP-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QaPE1mbOI6+D2pPfhpMA8LmWXKqkOoLLBQSVxdlNkoY=";
  };

  cargoHash = "sha256-qaDnMbAQA5c8Nim28HAN9QB1cxfBRaFAy8xh41Iekds=";

  checkFlags = [
    # Requires database access
    "--skip=test::checkconfig"
  ];

  nativeBuildInputs = [
    pkg-config
    perl
    libmysqlclient
    sqlite
  ];

  buildInputs = [
    openssl
    sqlite
    mariadb
    postgresql
    mbedtls
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
    description = "OCSP responder fetching certificate status from MySQL/MariaDB database";
    homepage = "https://github.com/DorianCoding/OCSP-server";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "ocsp-server";
  };
})
