{ pkgs, ... }:
{
  _class = "service";
  imports = [ pkgs.autopush-rs.services.autoendpoint ];
}
