{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  dbus,
  openssl_3,
}:
rustPlatform.buildRustPackage {
  pname = "cwe-client-cli";
  version = "0.2.0";
  buildInputs = [
    glib
    dbus
    openssl_3
  ];
  nativeBuildInputs = [ pkg-config ];

  src = fetchFromGitHub {
    owner = "NotBalds";
    repo = "cwe-client-cli";
    rev = "v0.2.0";
    hash = "sha256-L53pcbT6tKfQP1MVFsQ6xSiqmxayEBHcFuOkFwkqKyc=";
  };

  cargoHash = "sha256-VyeN3gzvZDIC7wzGhi9t9B9n/rIYLZ8MA6RLcHD/ZyI=";

  meta = {
    description = "Simple command line client for CWE";
    homepage = "https://github.com/NotBalds/cwe-client-cli";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tbwanderer ];
    mainProgram = "cwe-client-cli";
    platforms = lib.platforms.linux;
  };
}
