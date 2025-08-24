{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "minhtml";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "wilsonzlin";
    repo = "minify-html";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SoCSHhgTLfztSfvzxxpZn/nQpXbKlkE4iiP0YZ0MVjY=";
  };

  # Upstream does not include a lock file so one has to be patched in.
  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  # Ensures that only the correct package gets built, as upstream contains multiple.
  cargoBuildFlags = [
    "-p"
    "minhtml"
  ];
  cargoTestFlags = [
    "-p"
    "minhtml"
  ];

  meta = {
    description = "Minifier for HTML, JavaScript, and CSS";
    mainProgram = "minhtml";
    homepage = "https://github.com/wilsonzlin/minify-html";
    changelog = "https://github.com/wilsonzlin/minify-html/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tye-exe ];
  };
})
