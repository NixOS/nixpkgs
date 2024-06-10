{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

let
  dirname = "pdfpc-extractor";
in
rustPlatform.buildRustPackage rec {
  pname = "polylux2pdfpc";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "andreasKroepelin";
    repo = "polylux";
    rev = "v${version}";
    sparseCheckout = [ dirname ];
    hash = "sha256-GefX7XsUfOMCp2THstSizRGpKAoq7yquVukWQjGuFgc=";
  };
  sourceRoot = "${src.name}/${dirname}";

  cargoHash = "sha256-vmCaQxPkzz1ZVmtX7L3VeQb3kWhVqyPoQ1NrTSiJN9Y=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tool to make pdfpc interpret slides created by polylux correctly";
    homepage = "https://github.com/andreasKroepelin/polylux/tree/main/pdfpc-extractor";
    license = licenses.mit;
    mainProgram = "polylux2pdfpc";
    maintainers = [ maintainers.diogotcorreia ];
  };
}
