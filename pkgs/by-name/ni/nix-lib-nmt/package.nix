{
  lib,
  stdenv,
  fetchFromSourcehut,
}:

let
  version = "0.5.1";
in
stdenv.mkDerivation {
  pname = "nix-lib-nmt";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "nmt";
    rev = "v${version}";
    hash = "sha256-krVKx3/u1mDo8qe5qylYgmwAmlAPHa1BSPDzxq09FmI=";
  };

  outputHashMode = "recursive";
  outputHash = "sha256-N7kGGDDXsXtc1S3Nqw7lCIbnVHtGNNLM1oO+Xe64hSE=";

  installPhase = ''
    mkdir -pv "$out"
    cp -rv * "$out"
  '';

  meta = {
    homepage = "https://git.sr.ht/~rycee/nmt";
    description = "Basic test framework for projects using the Nixpkgs module system";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rycee ];
  };
}
