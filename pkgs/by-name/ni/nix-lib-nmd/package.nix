{
  lib,
  stdenv,
  fetchFromSourcehut,
}:

let
  version = "0.5.0";
in
stdenv.mkDerivation {
  pname = "nix-lib-nmd";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "nmd";
    rev = "v${version}";
    hash = "sha256-x3zzcdvhJpodsmdjqB4t5mkVW22V3wqHLOun0KRBzUI=";
  };

  outputHashMode = "recursive";
  outputHash = "sha256-7BQmDJBo7rzv0rgfRiUAR3HvKkUHQ6x0umhBRhAAyzM=";

  installPhase = ''
    mkdir -v "$out"
    cp -rv * "$out"
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~rycee/nmd";
    description = "Documentation framework for projects based on NixOS modules";
    license = licenses.mit;
    maintainers = with maintainers; [ rycee ];
  };
}
