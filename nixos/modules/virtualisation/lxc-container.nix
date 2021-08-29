{ lib, ... }:

with lib;

{
  imports = [
    ../profiles/docker-container.nix # FIXME, shouldn't include something from profiles/
  ];

  # Allow the user to login as root without password.
  users.users.root.initialHashedPassword = mkOverride 150 "";

  # Some more help text.
  services.getty.helpLine =
    ''

      Log in as "root" with an empty password.
    '';

  # Containers should be light-weight, so start sshd on demand.
  services.openssh.enable = mkDefault true;
  services.openssh.startWhenNeeded = mkDefault true;

  # Allow ssh connections
  networking.firewall.allowedTCPPorts = [ 22 ];
}
