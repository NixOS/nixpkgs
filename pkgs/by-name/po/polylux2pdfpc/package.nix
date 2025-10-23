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
    owner = "polylux-typ";
    repo = "polylux";
    tag = "v${version}";
    sparseCheckout = [ dirname ];
    hash = "sha256-41FgRejonvVTmE89WGm0Cqumm8lb6kkfxtkWV74UKJA=";
  };
  sourceRoot = "${src.name}/${dirname}";

  cargoHash = "sha256-9nA18f+Dwps45M/OIY0jtx7QgyJDTVUsPndFdNBKHCQ=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tool to make pdfpc interpret slides created by polylux correctly";
    homepage = "https://github.com/polylux-typ/polylux/tree/main/pdfpc-extractor";
    license = licenses.mit;
    mainProgram = "polylux2pdfpc";
    maintainers = [ maintainers.diogotcorreia ];
  };
}
