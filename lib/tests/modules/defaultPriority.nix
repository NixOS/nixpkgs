{ lib, config, ... }:

{
  options.values = {
    default = lib.mkOption {
      default = [ "foo" ];
      # No priority given
    };
    baseline = lib.mkOption {
      default = [ "foo" ];
      defaultPriority = lib.modules.priorities.baseline;
    };
    force = lib.mkOption {
      default = [ "foo" ];
      defaultPriority = lib.modules.priorities.force;
    };
  };

  config.values = {
    default = [ "bar" ];
    baseline = [ "bar" ];
    force = [ "bar" ];
  };
}
