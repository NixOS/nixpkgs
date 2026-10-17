{ config, lib, ... }:
{
  options.both = lib.mkOption {
    type = config.contractTypes.number.mkProviderType {
      fulfill = _: { };
      fulfill' = _: { };
    };
  };
  config.both.x.request.value = 1;
}
