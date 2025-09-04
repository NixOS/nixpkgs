{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "rsign2";
  version = "0.6.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-SmrTMMHnB5r0K6zL9B2qJwyywFxUTidQDejnFsOTT4E=";
  };

  cargoHash = "sha256-eWPZROftFA0pTgFDl4AuUP5yO863ar+HAcjCRk5c+cA=";

  meta = with lib; {
    description = "Command-line tool to sign files and verify signatures";
    homepage = "https://github.com/jedisct1/rsign2";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rsign";
  };
}
