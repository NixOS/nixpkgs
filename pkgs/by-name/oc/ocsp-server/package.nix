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
  version = "0.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DorianCoding";
    repo = "OCSP-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ut8z1mlPCJQjxw9hesle30OH/LDhGtZgmCyqTJ8ZzIo=";
  };

  cargoHash = "sha256-cWmabU49p8Fl5xwZ8FQvlg9rySriYav5Zo/bwIdGgX4=";

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
