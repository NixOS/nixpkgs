{ ioquake3, fetchFromGitHub, pan-bindings, libsodium, lib }:
ioquake3.overrideAttrs (old: {
  pname = "ioq3-scion";
  version = "unstable-2024-01-30";
  buildInputs = old.buildInputs ++ [
    pan-bindings
    libsodium];
  src = fetchFromGitHub {
    owner = "lschulz";
    repo = "ioq3-scion";
    rev = "a92e7e251c8d792d43a51c45041540ebba2bee2b";
    hash = "sha256-OsC2LkTJjR/qvZYGhKwtu5is3VoMwWzsqDeglqfXxSQ=";
  };
  meta = {
    description = "ioquake3 with support for path aware networking";
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
})
