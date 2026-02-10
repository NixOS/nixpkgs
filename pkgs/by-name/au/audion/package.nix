{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "audion";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "audiusGmbH";
    repo = "audion";
    tag = finalAttrs.version;
    hash = "sha256-NtAzh7n5bJXMt73L+FJU3vuNoNgga3wYXdZ2TY8AjIA=";
  };

  cargoHash = "sha256-kIrbHt6aAUgdF4Jx/aUOYpiBj1+pyFLCVak6R+JN2Ug=";

  meta = {
    description = "Ping the host continuously and write results to a file";
    homepage = "https://github.com/audiusGmbH/audion";
    changelog = "https://github.com/audiusGmbH/audion/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "audion";
  };
})
