{
  imports = [ ./lxc-image.nix ];

  # 2022-03-14
  warnings = [
    ''
      The file `nixos/modules/virtualisation/lxc-container.nix` was renamed to
      `nixos/modules/virtualisation/lxc-image.nix`.
      If you don't want to build an installation image for LXC, but just want
      to use a profile for a running container, you might want to use
      `nixos/modules/profiles/lxc-container.nix` instead.
    ''
  ];

}
