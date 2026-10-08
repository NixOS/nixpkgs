{
  fetchFromGitHub,
  gf2x,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "delsum";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "8051Enthusiast";
    repo = "delsum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-trCH2LIC3hjm3MMEoVGO2AY33eYTfn4N2mm2rOfUwt4=";
  };

  cargoHash = "sha256-Flz7h2/i4WIGr8CgVjpbCGHUkkGKSiHw5wlOIo7uuXo=";

  buildInputs = [
    gf2x
  ];

  meta = {
    homepage = "https://github.com/8051Enthusiast/delsum";
    description = "Reverse engineer's checksum toolbox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timschumi ];
    mainProgram = "delsum";
  };
})
