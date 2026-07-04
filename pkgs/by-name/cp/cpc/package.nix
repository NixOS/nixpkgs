{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cpc";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "probablykasper";
    repo = "cpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gd2bFOyPERcwTGurJJDMNrRjFq7smtkgFMGUXxZVwaI=";
  };

  cargoHash = "sha256-visApJ3DgQ1ohaQ2IE63bzdf0RuQI4NnpQqspP8WKjg=";

  meta = {
    mainProgram = "cpc";
    description = "Text calculator with support for units and conversion";
    homepage = "https://github.com/probablykasper/cpc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      s0me1newithhand7s
    ];
  };
})
