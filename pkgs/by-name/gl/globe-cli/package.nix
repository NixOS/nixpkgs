{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "globe-cli";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Np1f/mSMIMZU3hE0Fur8bOHhOH3rZyroGiVAqfiIs7g=";
  };

  cargoHash = "sha256-pcmxtkj3+sS0TytQjrfQLc6qm2JUxtp82VNyvybl9vU=";

  meta = with lib; {
    description = "Display an interactive ASCII globe in your terminal";
    homepage = "https://github.com/adamsky/globe";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ devhell ];
    mainProgram = "globe";
  };
}
