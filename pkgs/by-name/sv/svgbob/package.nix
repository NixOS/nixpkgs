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

  useFetchCargoVendor = true;
  cargoHash = "sha256-nMo8qO0dKwtZJY78+r4kLrR9Cw6Eu5Hq8IPp6ilJqfk=";

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
