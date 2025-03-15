{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  mariadb,
  mbedtls,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "ocsp-server";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "OCSP-server";
    rev = "87ad9edb4689fed120b932287b38e2be67bb5fa3";
    hash = "sha256-I02u7sADX8cCq+/cbZC0wx7qGRmwEeGZh2ms1NjvEoU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2/rvbm7oBfn21P9iZ1PZ3y6xmddk+NPKeX5OsBaK4ms=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    mariadb
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
    homepage = "https://github.com/DorianCoding/OCSP_server";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "ocsp-server";
  };
}
