{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "0.7.4";

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
    hash = "sha256-qSY12WjSPMoWqJHkYnPvhCtZAuI3eq+sA+/Yr9Yssp8=";
  };

  cargoHash = "sha256-dgOEztAlX823M+bc+vnrOvmeWtxxCsCR6+k1Yho82EM=";

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
