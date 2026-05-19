{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gen-license";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "nexxeln";
    repo = "license-generator";
    rev = "${finalAttrs.version}";
    hash = "sha256-VOmt8JXd2+ykhkhupv/I4RfXz9P0eEesW3JGAoXStUI=";
  };

  cargoHash = "sha256-xXzUobB8RMyJOC4lKayE+6SKC7NW1dNWGUUH3i1TaW0=";

  meta = {
    description = "Create licenses for your projects right from your terminal";
    mainProgram = "gen-license";
    homepage = "https://github.com/nexxeln/license-generator";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryanccn ];
  };
})
