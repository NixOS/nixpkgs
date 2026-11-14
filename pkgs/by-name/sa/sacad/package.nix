{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sacad";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "sacad";
    tag = finalAttrs.version;
    hash = "sha256-h4XefWw1f13uw77JnUVlQ+w5CeBcMcqCk6eXn5LTc+c=";
  };

  cargoHash = "sha256-euPVf/CORH7dqH0+H8Q/Grg6hARlY5N/hhWFdn8BSUg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    aws-lc
  ];

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
