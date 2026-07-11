{ pkgs, ... }:
{
  _class = "service";
  imports = [ pkgs.snid.services.default ];
}
