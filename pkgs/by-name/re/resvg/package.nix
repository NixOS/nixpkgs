{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "resvg";
    rev = "v${version}";
    hash = "sha256-sz1fAvg5HiBJpAgH7Vy0j5eAkvW8egcHyUXCsZzOWT8=";
  };

  cargoHash = "sha256-jUq1BvHgs3tEI+ye04FykdunHcMMatE3Gamr3grNWQw=";

  cargoBuildFlags = [
    "--package=resvg"
    "--package=resvg-capi"
    "--package=usvg"
  ];

  postInstall = ''
    install -Dm644 -t $out/include crates/c-api/*.h
  '';

  meta = {
    description = "SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    changelog = "https://github.com/RazrFalcon/resvg/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    mainProgram = "resvg";
  };
}
