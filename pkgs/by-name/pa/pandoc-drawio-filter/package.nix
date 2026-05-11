{
  python3Packages,
  drawio-headless,
  fetchFromGitHub,
  lib,
  pandoc,
  runCommand,
  texliveTeTeX,
}:

let
  version = "1.1";

  src = fetchFromGitHub {
    owner = "tfc";
    repo = "pandoc-drawio-filter";
    rev = version;
    sha256 = "sha256-2XJSAfxqEmmamWIAM3vZqi0mZjUUugmR3zWw8Imjadk=";
  };

  pandoc-drawio-filter = python3Packages.buildPythonApplication {
    format = "setuptools";
    pname = "pandoc-drawio-filter";

    inherit src version;

    propagatedBuildInputs = [
      drawio-headless
      python3Packages.pandocfilters
    ];

    passthru.tests.example-doc =
      let
        env = {
          nativeBuildInputs = [
            pandoc
            pandoc-drawio-filter
            texliveTeTeX
          ];
        };
      in
      runCommand "$pandoc-drawio-filter-example-doc.pdf" env ''
        cp -r ${src}/example/* .
        pandoc -F pandoc-drawio example.md -T pdf -o $out
      '';

    meta = {
      homepage = "https://github.com/tfc/pandoc-drawio-filter";
      description = "Pandoc filter which converts draw.io diagrams to PDF";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ tfc ];
      mainProgram = "pandoc-drawio";
    };
  };

in

pandoc-drawio-filter
