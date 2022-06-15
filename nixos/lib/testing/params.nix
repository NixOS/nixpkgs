{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    params = mkOption {
      description = ''
        A namespace for ad-hoc definitions that you can override in options
        such as `interactive` and `matrix.<choice>.values.<name>.module`.

        These definitions are available in the `params` module argument.
      '';
      type = types.lazyAttrsOf types.raw;
      default = {};
    };
  };
  config = {
    _module.args.params = config.params;
  };
}
