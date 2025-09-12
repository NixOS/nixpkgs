{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hullcaster";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "gilcu3";
    repo = "hullcaster";
    tag = "v${version}";
    hash = "sha256-TaELX/xMxm7OTmVnvkgEmdhnVrIlxSNqlE73+I5qxCc=";
  };

  cargoHash = "sha256-jso9ofchUjpsck0qJN3rfFVM1Y6C8APmhwNzapU7Mug=";

  # work around error: Could not create filepath: /homeless-shelter/.local/share
  checkFlags = [
    "--skip gpodder::tests::gpodder"
  ];

  meta = {
    description = "Terminal-based podcast manager built in Rust";
    homepage = "https://github.com/gilcu3/hullcaster";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kiara ];
  };
}
