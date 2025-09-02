{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sig";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "sig";
    rev = "v${version}";
    hash = "sha256-5e2EMpozHbLgLFOhCmaMd5Wtc1Or+bnKgPqbK4E/smY=";
  };

  cargoHash = "sha256-bb5qXUAE0H3JmMgUhGRKH1rks8Eeh9fNCeIFfKvUXGo=";

  meta = {
    description = "Interactive grep (for streaming)";
    homepage = "https://github.com/ynqa/sig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qaidvoid ];
    mainProgram = "sig";
  };
}
