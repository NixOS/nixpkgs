{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obah";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "galister";
    repo = "obah";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s4YvyNm/XBiRQc2WQqkrHun2+vn4vXf1Okzw040gtsc=";
  };

  cargoHash = "sha256-o71CVr5Zr2ZGzRfJbqXxGMX8HZbOW0Cyf6mk2isUHEs=";
  cargoDepsName = finalAttrs.pname;

  __structuredAttrs = true;

  meta = {
    description = "OpenVR bindings TUI for xrizer, VapoR and OpenComposite";
    homepage = "https://github.com/galister/obah";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "obah";
  };
})
