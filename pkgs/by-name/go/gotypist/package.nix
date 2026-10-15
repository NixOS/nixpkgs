{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gotypist";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "pb-";
    repo = "gotypist";
    rev = finalAttrs.version;
    hash = "sha256-IUj5DQ7rnr/bcCH4vMcO82bV9MfE0Zo41UEEuowTFE4=";
  };

  vendorHash = null;

  meta = {
    description = "Touch-typing tutor";
    mainProgram = "gotypist";
    longDescription = ''
      A simple touch-typing tutor that follows Steve Yegge's methodology of
      going in fast, slow, and medium cycles.
    '';
    homepage = "https://github.com/pb-/gotypist";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pb- ];
  };
})
