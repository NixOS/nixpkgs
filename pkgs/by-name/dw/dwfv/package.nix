{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "dwfv";
  version = "0.4.1";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-JzOD0QQfDfIkJQATxGpyJBrFg5l6lkkAXY2qv9bir3c=";
  };

  cargoHash = "sha256-nmnpHz9sCRlxOngcSrW+oktYIKM/A295/a03fUf3ofw=";

  meta = {
    description = "Simple digital waveform viewer with vi-like key bindings";
    mainProgram = "dwfv";
    homepage = "https://github.com/psurply/dwfv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ newam ];
  };
}
