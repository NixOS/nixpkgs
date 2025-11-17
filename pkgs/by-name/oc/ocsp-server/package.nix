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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "DorianCoding";
    repo = "OCSP-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7JYefylOs+Chqejt+hpB1AD4FTdbIhfKS1He4xAFMLo=";
  };

  cargoHash = "sha256-2wtQO6Mp4rkeklpCDKFRre5WGao7dQd+Mmma80QRo00=";

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
