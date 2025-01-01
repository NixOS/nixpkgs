{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildGoModule,
}:
buildGoModule rec {
  pname = "json-plot";
  version = "1.1.12";

  src = fetchFromGitHub {
    owner = "sgreben";
    repo = "jp";
    rev = version;
    hash = "sha256-WWARAh/CF3lGli3VLRzAGaCA8xQyryPi8WcuwvdInjk=";
  };

  vendorHash = "sha256-EPrlaUHAGATNFv3qgWKGmJdu9EHsV/0DJKEvQck+fWc=";

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/sgreben/jp/commit/9516fb4d7c5b011071b4063ea8e8e9667e57a777.patch";
      hash = "sha256-Vz5HnStrCpMN1L7dne7JDX5F57up3EBPPf/9hN9opRc=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Dead simple terminal plots from JSON (or CSV) data. Bar charts, line charts, scatter plots, histograms and heatmaps are supported";
    homepage = "https://github.com/sgreben/jp";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "jp";
  };
}
