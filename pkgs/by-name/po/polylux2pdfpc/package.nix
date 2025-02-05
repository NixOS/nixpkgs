{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

let
  dirname = "pdfpc-extractor";
in
rustPlatform.buildRustPackage rec {
  pname = "polylux2pdfpc";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "andreasKroepelin";
    repo = "polylux";
    rev = "v${version}";
    sparseCheckout = [ dirname ];
    hash = "sha256-41FgRejonvVTmE89WGm0Cqumm8lb6kkfxtkWV74UKJA=";
  };
  sourceRoot = "${src.name}/${dirname}";

  cargoHash = "sha256-M5NGHDbGk8bz0RRfzA1o/6vWpc2FkGF0jdlJG7LY9cI=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tool to make pdfpc interpret slides created by polylux correctly";
    homepage = "https://github.com/andreasKroepelin/polylux/tree/main/pdfpc-extractor";
    license = licenses.mit;
    mainProgram = "polylux2pdfpc";
    maintainers = [ maintainers.diogotcorreia ];
  };
}
