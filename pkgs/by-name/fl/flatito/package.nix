{
  lib,
  ruby,
  buildRubyGem,
  bundlerEnv,
  bundlerUpdateScript,
}:
let
  deps = bundlerEnv rec {
    inherit ruby;
    name = "flatito-${version}";
    version = "0.1.1";
    gemdir = ./.;
    gemset = lib.recursiveUpdate (import ./gemset.nix) {
      flatito.source = {
        remotes = [ "https://rubygems.org" ];
        sha256 = "9f5a8f899a14c1a0fe74cb89288f24ddc47bd5d83ac88ac8023d19b056ecb50f";
        type = "gem";
      };
    };
  };
in

buildRubyGem rec {
  inherit ruby;

  gemName = "flatito";
  pname = gemName;
  version = "0.1.1";

  source.sha256 = "sha256-n1qPiZoUwaD+dMuJKI8k3cR71dg6yIrIAj0ZsFbstQ8=";
  propagatedBuildInputs = [ deps ];

  passthru.updateScript = bundlerUpdateScript "${pname}";

  meta = with lib; {
    description = "Grep for keys in YAML and JSON files";
    homepage = "https://github.com/ceritium/flatito";
    license = licenses.mit;
    maintainers = with maintainers; [ rucadi ];
    platforms = platforms.unix;
    mainProgram = "flatito";
  };
}
