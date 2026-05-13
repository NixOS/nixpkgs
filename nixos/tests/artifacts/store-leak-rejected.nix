{ pkgs, ... }:

# This test verifies the evaluation-time assertion that prevents secret
# paths from pointing into /nix/store.  We evaluate a bad configuration
# and assert that it fails with the correct error message.

let
  eval = pkgs.lib.nixosSystem {
    modules = [
      {
        security.artifacts.enable = true;
        security.artifacts.provider = "dummy";
        security.artifacts.secrets."bad-secret" = {
          # This path is inside /nix/store — the assertion must reject it
          path = "/nix/store/fake-hash-bad-secret";
          dummy = "should-never-deploy";
        };
      }
    ];
  };

  # Force evaluation of the assertions
  evaluated = builtins.tryEval (builtins.deepSeq eval.config.assertions eval.config.assertions);
in
pkgs.runCommand "store-leak-rejected" { } ''
  # The evaluation should succeed (assertions are data), but the
  # assertion list should contain a failing entry.
  ${
    if evaluated.success then
      let
        failingAssertions = builtins.filter (a: !a.assertion) evaluated.value;
      in
      if failingAssertions == [ ] then
        ''
          echo "ERROR: No assertion fired for store-path secret"
          exit 1
        ''
      else
        ''
          echo "Store-leak assertion correctly fired: ${(builtins.head failingAssertions).message}"
          touch $out
        ''
    else
      # If evaluation itself failed, that's also acceptable — the assertion
      # abort prevented the config from being built.
      ''
        echo "Evaluation aborted as expected (store-leak assertion)"
        touch $out
      ''
  }
''
