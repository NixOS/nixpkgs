# nix-build '<nixpkgs/nixos>' -A config.system.build.openstackImage --arg configuration "{ imports = [ ./nixos/maintainers/scripts/openstack/openstack-image.nix ]; }"

{
  config,
  lib,
  pkgs,
  ...
}:
let
  copyChannel = true;
in
{
  imports = [
    ../../../modules/virtualisation/openstack-config.nix
  ] ++ (lib.optional copyChannel ../../../modules/installer/cd-dvd/channel.nix);

  documentation.enable = copyChannel;

  system.build.openstackImage = import ../../../lib/make-disk-image.nix {
    inherit lib config copyChannel;
    additionalSpace = "1024M";
    pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package
    format = "qcow2";
    configFile = pkgs.writeText "configuration.nix" ''
      {
        imports = [ <nixpkgs/nixos/modules/virtualisation/openstack-config.nix> ];
      }
    '';
  };

}
