{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XjWkzTdsnQZfBjf61dgGt/a7973ZljJG1rnCk0iGk6Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NHXcBKSuyL0bIriEOr1nuTnz4vra1bIYcNOGmnN5HnQ=";

  cargoBuildFlags = [
    "--package=resvg"
    "--package=resvg-capi"
    "--package=usvg"
  ];

  postInstall = ''
    install -Dm644 -t $out/include crates/c-api/*.h
  '';

  meta = with lib; {
    description = "SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    changelog = "https://github.com/RazrFalcon/resvg/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ ];
    mainProgram = "resvg";
  };
}
