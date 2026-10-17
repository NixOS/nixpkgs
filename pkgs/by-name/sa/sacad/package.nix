{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sacad";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "sacad";
    tag = finalAttrs.version;
    hash = "sha256-fZLulpOspQooIGOnI+RwQ64J4Qf9iVRqOpiW5T3NV6A=";
  };

  cargoHash = "sha256-Xu1oI0N93yQuXbr+Td6giMO/om3RwUQLHZKVL5P+FyI=";

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
