# Heavily based on
# https://github.com/risicle/nix-heuristic-gc/blob/0.6.0/default.nix
{
  lib,
  fetchFromGitHub,
  nix,
  boost,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "nix-heuristic-gc";
  version = "0.6.1";
  src = fetchFromGitHub {
    owner = "risicle";
    repo = "nix-heuristic-gc";
    tag = "v${version}";
    hash = "sha256-3SSIbfOx6oYsCZgK71bbx2H3bAMZ3VJxWfiMVPq5FaE=";
  };

  # NIX_SYSTEM suggested at
  # https://github.com/NixOS/nixpkgs/issues/386184#issuecomment-2692433531
  NIX_SYSTEM = nix.stdenv.hostPlatform.system;
  NIX_CFLAGS_COMPILE = [ "-I${lib.getDev nix}/include/nix" ];

  buildInputs = [
    boost
    nix
    python3Packages.pybind11
    python3Packages.setuptools
  ];
  propagatedBuildInputs = [
    python3Packages.humanfriendly
    python3Packages.rustworkx
  ];
  checkInputs = [ python3Packages.pytestCheckHook ];

  preCheck = "mv nix_heuristic_gc .nix_heuristic_gc";

  meta = {
    mainProgram = "nix-heuristic-gc";
    description = "Discerning garbage collection for Nix";
    longDescription = ''
      A more discerning cousin of `nix-collect-garbage`, mostly intended as a
      testbed to allow experimentation with more advanced selection processes.
    '';
    homepage = "https://github.com/risicle/nix-heuristic-gc";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      ris
      me-and
    ];
  };
}
