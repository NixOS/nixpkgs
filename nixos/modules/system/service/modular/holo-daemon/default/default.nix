{ pkgs, ... }:
{
  _class = "service";
  imports = [ pkgs.holo-daemon.services.default ];
}
