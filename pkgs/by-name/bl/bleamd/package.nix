{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  __structuredAttrs = true;

  pname = "bleamd";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "guttermonk";
    repo = "bleamd";
    rev = "v${version}";
    hash = "sha256-uWh8GaYiLNNmich+/Ir7xTRXBokzKf0HaRHzoQVUccc=";
  };

  vendorHash = "sha256-s7SEUAt9SJEDm8+1N5cb5+mM9M6H7tAfSzZKczu/60s=";

  meta = {
    description = "Fast, interactive markdown viewer with search, theming, and clickable links for the terminal";
    homepage = "https://github.com/guttermonk/bleamd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guttermonk ];
    mainProgram = "bleamd";
  };
}
