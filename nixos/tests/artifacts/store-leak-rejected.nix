{ pkgs, ... }:

let
  # Create a configuration that deliberately attempts to leak to the store
  badConfig = pkgs.nixos {
    
    security.artifacts.enable = true;
    security.artifacts.provider = "dummy";
    security.artifacts.secrets."bad-secret" = {
      path = pkgs.writeText "leak" "will-leak";
      dummy = "leak";
    };
  };
in pkgs.runCommand "test-store-leak-rejected" {} ''
  # We expect evaluation to fail. If it succeeds, the test fails.
  if nix-instantiate --eval --expr '(import ${badConfig.config.system.build.toplevel} {}).config.system.build.toplevel' 2> err; then
    echo "Evaluation succeeded when it should have failed!"
    exit 1
  fi
  if ! grep -q "would leak into the Nix store" err; then
    echo "Evaluation failed, but for the wrong reason:"
    cat err
    exit 1
  fi
  touch $out
''
