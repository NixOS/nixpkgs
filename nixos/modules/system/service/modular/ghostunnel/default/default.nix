{ pkgs, ... }:
{
  _class = "service";
  imports = [ pkgs.ghostunnel.services.default ];
}
