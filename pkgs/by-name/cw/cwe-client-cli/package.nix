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
    hash = "sha256-pL0jPS+zNRI+ED08LBBKb1ql4fxEVrKAsC8Upy2i/2U=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    dbus
    openssl_3
  ];
  cargoHash = "sha256-TqaS5zdYHYjHtf4NXX8TRlGlDogn9w6TntaATCNFxS4=";

  meta = {
    description = "Simple command line client for CWE";
    homepage = "https://github.com/NotBalds/cwe-client-cli";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tbwanderer ];
    mainProgram = "cwe-client-cli";
    platforms = lib.platforms.linux;
  };
}
