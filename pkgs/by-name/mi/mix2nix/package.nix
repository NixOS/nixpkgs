{
  stdenv,
  lib,
  fetchFromGitHub,
  elixir,
  erlang,
}:

stdenv.mkDerivation rec {
  pname = "mix2nix";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ydlr";
    repo = "mix2nix";
    rev = version;
    hash = "sha256-hD4lpP8GPkNXuMMDOOTEmy+rOwOSCxQwR0Mjq8i4oDM=";
  };

  nativeBuildInputs = [ elixir ];
  buildInputs = [ erlang ];

  buildPhase = "mix escript.build";
  installPhase = "install -Dt $out/bin mix2nix";

  meta = with lib; {
    description = "Generate nix expressions from mix.lock file";
    mainProgram = "mix2nix";
    license = licenses.mit;
    maintainers = with maintainers; [ ydlr ] ++ teams.beam.members;
  };
}
