{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sacad";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "sacad";
    tag = finalAttrs.version;
    hash = "sha256-dzVppb6Lg/yjLrPAwII/GMy+56jzaWn0WS7vRZOXkgU=";
  };

  cargoHash = "sha256-tySgM7j26vztPOGkIq1kQeZn6YwDbk9mt3SEg94SW2o=";

  # Tests require internet connection.
  doCheck = false;

  meta = {
    description = "Smart Automatic Cover Art Downloader";
    homepage = "https://github.com/desbma/sacad";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ moni ];
    mainProgram = "sacad";
  };
})
