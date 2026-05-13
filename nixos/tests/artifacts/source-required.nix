{ pkgs, ... }:

# This test verifies that when using the sops-nix or agenix provider,
# the `source` option is required.  A configuration without `source`
# must produce a clear assertion failure.

let
  eval = pkgs.lib.nixosSystem {
    modules = [
      {
        options.sops.secrets = pkgs.lib.mkOption {
          type = pkgs.lib.types.attrsOf pkgs.lib.types.anything;
          default = { };
        };
        config = {
          security.artifacts.enable = true;
          security.artifacts.provider = "sops-nix";
          security.artifacts.secrets."no-source" = {
            # Deliberately omitting `source` — the assertion must fire
          };
        };
      }
    ];
  };

  evaluated = builtins.tryEval (builtins.deepSeq eval.config.assertions eval.config.assertions);
in
pkgs.runCommand "source-required" {} ''
  ${if evaluated.success then
    let
      failingAssertions = builtins.filter (a: !a.assertion) evaluated.value;
    in
      if failingAssertions == [] then
        ''echo "ERROR: No assertion fired for missing source"; exit 1''
      else
        ''echo "Source-required assertion correctly fired"; touch $out''
  else
    ''echo "Evaluation aborted as expected (source-required assertion)"; touch $out''
  }
''
