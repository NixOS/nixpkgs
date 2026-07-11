{ pkgs, ... }:
{
  _class = "service";
  imports = [ pkgs.php.services.default ];
}
