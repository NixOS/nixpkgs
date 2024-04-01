{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    meta = lib.mkOption {
      description = ''
        The [`meta`](https://nixos.org/manual/nixpkgs/stable/#chap-meta) attributes that will be set on the returned derivations.

        Not all [`meta`](https://nixos.org/manual/nixpkgs/stable/#chap-meta) attributes are supported, but more can be added as desired.
      '';
      apply = lib.filterAttrs (k: v: v != null);
      type = types.submodule {
        options = {
          maintainers = lib.mkOption {
            type = types.listOf types.raw;
            default = [];
            description = ''
              The [list of maintainers](https://nixos.org/manual/nixpkgs/stable/#var-meta-maintainers) for this test.
            '';
          };
          timeout = lib.mkOption {
            type = types.nullOr types.int;
            default = 3600;  # 1 hour
            description = ''
              The [{option}`test`](#test-opt-test)'s [`meta.timeout`](https://nixos.org/manual/nixpkgs/stable/#var-meta-timeout) in seconds.
            '';
          };
          broken = lib.mkOption {
            type = types.bool;
            default = false;
            description = ''
              Sets the [`meta.broken`](https://nixos.org/manual/nixpkgs/stable/#var-meta-broken) attribute on the [{option}`test`](#test-opt-test) derivation.
            '';
          };
        };
      };
      default = {};
    };
  };
}
