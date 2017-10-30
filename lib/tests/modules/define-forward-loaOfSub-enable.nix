{ lib, config, ... }:

{
  config = {
    enable = lib.mkForwardSubmoduleOptionDefinitions
      (lib.attrValues config.loaOfSub) (cfg: cfg.enable);
  };
}
