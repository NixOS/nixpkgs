{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nirius";
  version = "0.10.0";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "nirius";
    rev = "nirius-${finalAttrs.version}";
    hash = "sha256-ngsLkbCuHF+zSupU1b1EHXW+uwyN2QpqWGWBY6qar2w=";
  };

  cargoHash = "sha256-5UvJ5g4p0sUicLxEnC+h9ednHqwdlSSuTfDjgmeNSd0=";

  meta = {
    description = "Utility commands for the niri wayland compositor";
    mainProgram = "nirius";
    homepage = "https://git.sr.ht/~tsdh/nirius";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tylerjl ];
    platforms = lib.platforms.linux;
  };
})
