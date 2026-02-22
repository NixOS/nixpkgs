{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resvg";
  version = "0.46.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "resvg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kiE9Zv3PonRRq6pbRnqGz0LKlYSTFSuuqYaLDmC9I2Y=";
  };

  cargoHash = "sha256-dqqO+CPyBaUFBZGwhwXFRr8tnZWp27sF0606tmOm7ms=";

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
    changelog = "https://github.com/RazrFalcon/resvg/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    mainProgram = "resvg";
  };
})
