{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  makeWrapper,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "oxdraw";
  version = "0.2.0";
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Gcnh3VdcET2BV2LZb/KAn6gjdgdWoyFy0ORogHpWOBs=";
  };
  cargoHash = "sha256-YedNESkXKbfl7FWea7VpDR+59b9WLtZ7GNcyJ7D9yPg=";
  cargoBuildFlags = [ "--bin oxdraw" ]; # Don't build library.

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ];

  # Setting OXDRAW_WEB_DIST here because buildRustPackage doesn't support build.rs.
  postInstall = ''
    wrapProgram $out/bin/oxdraw \
      --set OXDRAW_WEB_DIST "${src}/frontend/out"
  '';

  meta = {
    description = "Mermaid diagram tool with draggable editing";
    homepage = "https://github.com/RohanAdwankar/oxdraw";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ push_f ];
    mainProgram = "oxdraw";
  };
}
