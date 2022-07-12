{ lib, ... }:{

  # Allow the user to login as root without password.
  users.users.root.initialHashedPassword = lib.mkOverride 150 "";

  # Some more help text.
  services.getty.helpLine =
    ''

      Log in as "root" with an empty password.
    '';

  # Containers should be light-weight, so start sshd on demand.
  services.openssh.enable = lib.mkDefault true;
  services.openssh.startWhenNeeded = lib.mkDefault true;

}

