{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  perl,
  libmysqlclient,
  mariadb,
  postgresql,
  mbedtls,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ocsp-server";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "DorianCoding";
    repo = "OCSP-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xYZ2NM+U7ZW5xDKVUhT+s66i/d7zaDLBbSbr6TDOG0o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RFrm2dtjJ2VvOg8ee54ps8MuWgsV0kd9rhpzOFTem2k=";

  nativeBuildInputs = [
    pkg-config
    perl
    libmysqlclient
  ];

  buildInputs = [
    openssl
    mariadb
    postgresql
    mbedtls
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
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
