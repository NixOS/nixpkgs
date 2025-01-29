{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.7.6";

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
    hash = "sha256-mPF6GcsXl/Bcri9d8SS21+/sjssT4//ktwC620NrEUg=";
  };

  cargoHash = "sha256-WXjHcfccoZa+7hqFfA4vbWLMlhbkfafG1Fgilbmi60E=";

  postInstall = ''
    mv $out/bin/svgbob_cli $out/bin/svgbob
  '';

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    changelog = "https://github.com/ivanceras/svgbob/raw/${version}/Changelog.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "svgbob";
  };
}
