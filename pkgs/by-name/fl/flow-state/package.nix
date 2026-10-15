{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flow_state";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "Stan-breaks";
    repo = "flow_state";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xi/4vjLwpobElS5gfJKcAekItoY23p7UoMBxmGcOT0E=";
  };

  cargoHash = "sha256-Sg8fxKdoZQpXR3TMY5q2b0bu4/Lqa67HqmQktdCcJK0=";

  meta = {
    description = "Terminal-based habit tracker designed for neurodivergent users";
    mainProgram = "flow_state";
    homepage = "https://github.com/Stan-breaks/flow_state";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      overloader
    ];
  };
})
