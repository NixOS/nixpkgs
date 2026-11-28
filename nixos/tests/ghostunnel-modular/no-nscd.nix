{ lib, ... }:
{
  imports = [ ./default.nix ];
  name = lib.mkForce "ghostunnel-modular-no-nscd";
  nodes.service = {
    # Without nscd, ghostunnel reads /etc/hosts itself.
    services.nscd.enable = false;
    system.nssModules = lib.mkForce [ ];
  };
}
