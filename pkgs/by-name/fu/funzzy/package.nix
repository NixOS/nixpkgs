{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "funzzy";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "cristianoliveira";
    repo = "funzzy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3EHZvgHlM3ldX6SEyqGf6MZIrDFOLXbKTZnJNczT570=";
  };

  cargoHash = "sha256-n9UHyr7W4hrN0+2dsYAYqkP/uzBv74p5XHU0g2MReJY=";

  meta = {
    description = "Lightweight watcher";
    homepage = "https://github.com/cristianoliveira/funzzy";
    changelog = "https://github.com/cristianoliveira/funzzy/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
