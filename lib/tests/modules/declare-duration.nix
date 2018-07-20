{ config, lib, ... }:

with lib;

{
  options = {
    value = mkOption {
      type = types.duration;
      apply = durations.parse;
    };

    result = mkOption {
      type = types.str;
    };
  };

  config.result = toString config.value;
}
