{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  gitMinimal,
  serie,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "serie";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xHIqyjaC7TrLGRof3uPiKZG67xBJK8zC21l2UG+8Mm0=";
  };

  cargoHash = "sha256-JjeHDFs8PY+1nqSxTeBAeVaskUSq9AD1jhMQeG/EpSo=";

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

  meta = {
    description = "Rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
})
