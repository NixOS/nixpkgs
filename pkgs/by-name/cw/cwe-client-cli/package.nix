{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  dbus,
  openssl_3,
}:
rustPlatform.buildRustPackage rec {
  pname = "cwe-client-cli";
  version = "0.3.3";
  src = fetchFromGitHub {
    owner = "NotBalds";
    repo = "cwe-client-cli";
    rev = "v${version}";
    hash = "sha256-3ehzERWV0/hV0Suy9LtCcp+xmaD13Chgu4a0gPT7cHs=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    dbus
    openssl_3
  ];
  cargoHash = "sha256-iQ8b5+VNU89RiO4t4rI9ULwFv6KS71oVycHT7BeF8jQ=";

  meta = {
    description = "Simple command line client for CWE";
    homepage = "https://github.com/NotBalds/cwe-client-cli";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tbwanderer ];
    mainProgram = "cwe-client-cli";
    platforms = lib.platforms.linux;
  };
}
