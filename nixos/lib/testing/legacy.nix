{ config, options, lib, ... }:
let
  inherit (lib) mkIf mkOption types;
in
{
  # This needs options.warnings and options.assertions, which we don't have (yet?).
  # imports = [
  #   (lib.mkRenamedOptionModule [ "machine" ] [ "nodes" "machine" ])
  #   (lib.mkRemovedOptionModule [ "minimal" ] "The minimal kernel module was removed as it was broken and not used any more in nixpkgs.")
  # ];

  options = {
    machine = mkOption {
      internal = true;
      type = types.raw;
    };
  };

  config = {
    nodes = mkIf options.machine.isDefined (
      lib.warn
        "In test `${config.name}': The `machine' attribute in NixOS tests (pkgs.nixosTest / make-test-python.nix / testing-python.nix / makeTest) is deprecated. Please set the equivalent `nodes.machine'."
        { inherit (config) machine; }
    );
  };
}
