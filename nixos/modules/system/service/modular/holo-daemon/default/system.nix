{ lib, ... }:
{
  # holo-daemon has no system (NixOS) specific configuration; this variant
  # exists so the service is advertised as supported on the NixOS system
  # environment.
  _class = "service";
  imports = [ ./default.nix ];
  meta.maintainers = with lib.maintainers; [ themadbit ];
}
