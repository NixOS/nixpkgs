{ lib, custom, ... }:

{
  config = {
    _module.args.custom = true;
    enable = custom;
  };
}
