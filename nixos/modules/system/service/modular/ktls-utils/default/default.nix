{ pkgs, ... }:
{
  _class = "service";
  imports = [ pkgs.ktls-utils.services.default ];
}
