{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resvg";
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "resvg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BCYjVOWFpOZm7ocmfszFpaBxnd96vhf3/yGlvAVRtCw=";
  };

  cargoHash = "sha256-cVOAmwX/pYA6R0HK8+RLt/IvzowAO/g1i2YM71bYFoA=";

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
