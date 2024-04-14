{lib, ...}:

{
  imports = [
    ./lxc-image-metadata.nix

    ../installer/cd-dvd/channel.nix
    ../profiles/clone-config.nix
    ../profiles/minimal.nix
  ];

  # Allow the user to login as root without password.
  users.users.root.initialHashedPassword = lib.mkOverride 150 "";

  # Some more help text.
  services.getty.helpLine = ''

    Log in as "root" with an empty password.
  '';

  # Containers should be light-weight, so start sshd on demand.
  services.openssh.enable = lib.mkDefault true;
  services.openssh.startWhenNeeded = lib.mkDefault true;

  # As this is intended as a standalone image, undo some of the minimal profile stuff
  environment.noXlibs = false;
  documentation.enable = true;
  documentation.nixos.enable = true;
  services.logrotate.enable = true;
}
