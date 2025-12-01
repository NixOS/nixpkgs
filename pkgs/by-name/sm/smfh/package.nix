{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smfh";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "feel-co";
    repo = "smfh";
    tag = finalAttrs.version;
    hash = "sha256-Pjq/Q+W0bapu0EDRlDYQxLjKHA0OHdVn7hWfJumjWdM=";
  };

  cargoHash = "sha256-ULU2fMVTeHvFM374GwZlHO5/a9bcf8AmwbqvXp1YRAk=";

  meta = {
    description = "Sleek Manifest File Handler";
    homepage = "https://github.com/feel-co/smfh";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      arthsmn
      gerg-l
    ];
    mainProgram = "smfh";
  };
})
