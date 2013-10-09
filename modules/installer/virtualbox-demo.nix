{ config, pkgs, ... }:

{
  imports =
    [ ../virtualisation/virtualbox-image.nix
      ../installer/cd-dvd/channel.nix
      ../profiles/demo.nix
      ../profiles/clone-config.nix
    ];

  # Allow mounting of shared folders.
  users.extraUsers.demo.extraGroups = [ "vboxsf" ];
}
