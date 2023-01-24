{ lib
, fetchFromGitHub
, buildGoPackage
}:
# upstream is pretty stale, but it still works, so until they merge module
# support we have to use gopath: see sgreben/jp#29
buildGoPackage rec {
  pname = "json-plot";
  version = "1.1.12";

  src = fetchFromGitHub {
    owner = "sgreben";
    repo = "jp";
    rev = version;
    hash = "sha256-WWARAh/CF3lGli3VLRzAGaCA8xQyryPi8WcuwvdInjk=";
  };

  goPackagePath = "github.com/sgreben/jp";

  meta = with lib; {
    description = "Dead simple terminal plots from JSON (or CSV) data. Bar charts, line charts, scatter plots, histograms and heatmaps are supported.";
    homepage = "https://github.com/sgreben/jp";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "jp";
  };
}
