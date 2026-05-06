{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsonpath";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "rsonquery";
    repo = "rsonpath";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lh58U5A4EeD+tQ3CZNE7YabwGIJ14Cv5dqbJ64JYNDk=";
  };

  cargoHash = "sha256-w1AODL95+O0jhzXvNrL9I+i2+jcZX3SvJDKrLWkI7c8=";

  cargoBuildFlags = [ "-p=rsonpath" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  meta = {
    description = "Experimental JSONPath engine for querying massive streamed datasets";
    homepage = "https://github.com/v0ldek/rsonpath";
    changelog = "https://github.com/v0ldek/rsonpath/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbutter ];
    mainProgram = "rq";
  };
})
