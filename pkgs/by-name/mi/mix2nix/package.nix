{
  stdenv,
  lib,
  fetchFromGitHub,
  beamPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mix2nix";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ydlr";
    repo = "mix2nix";
    rev = finalAttrs.version;
    hash = "sha256-hD4lpP8GPkNXuMMDOOTEmy+rOwOSCxQwR0Mjq8i4oDM=";
  };

  nativeBuildInputs = [ beamPackages.elixir ];
  buildInputs = [ beamPackages.erlang ];

  buildPhase = "mix escript.build";
  installPhase = "install -Dt $out/bin mix2nix";

  meta = {
    description = "Generate nix expressions from mix.lock file";
    mainProgram = "mix2nix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ydlr ];
    teams = [ lib.teams.beam ];
  };
})
