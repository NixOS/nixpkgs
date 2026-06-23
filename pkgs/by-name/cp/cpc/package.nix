{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cpc";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "probablykasper";
    repo = "cpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t9dAk0hIk8P/vt5wfQ5KvLU6f2DAllPy4BfB0q7F7CA=";
  };

  cargoHash = "sha256-Zb6rnJjhYruoQ7MxCfrx9doDr+hnhCDqhq23xWtdhUY=";

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
