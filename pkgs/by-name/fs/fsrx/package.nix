{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  fsrx,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fsrx";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "jrnxf";
    repo = "fsrx";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4tepUeNAMeIArxXt5BEJbOivwXA5B53QheWP93yxW0A=";
  };

  cargoHash = "sha256-AnpMpfPLeL3ztSkfPqYvERyh4D397gcvlk45A+fE0aU=";

  passthru = {
    tests.version = testers.testVersion {
      package = fsrx;
    };
  };

  meta = {
    description = "Flow state reader in the terminal";
    homepage = "https://github.com/jrnxf/fsrx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    mainProgram = "fsrx";
  };
})
