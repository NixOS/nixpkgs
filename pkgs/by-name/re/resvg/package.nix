{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resvg";
  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "linebender";
    repo = "resvg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rzTmbk1pt9plH2yIyNUD/zgyz2xrlpxU6pyz+puEw/A=";
  };

  cargoHash = "sha256-dhFymHs3BliU0lSqtUEiu9FTeGfdP47KtokZFOJAheI=";

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
    homepage = "https://github.com/linebender/resvg";
    changelog = "https://github.com/linebender/resvg/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    mainProgram = "resvg";
  };
})
