# nix-build '<nixpkgs/nixos>' -A config.system.build.openstackImage --arg configuration "{ imports = [ ./nixos/maintainers/scripts/openstack/openstack-image.nix ]; }"

{
  config,
  lib,
  pkgs,
  ...
}:
let
  copyChannel = true;
  format = "qcow2";
in
{
  imports = [
    ../../../modules/virtualisation/openstack-config.nix
    ../../../modules/image/file-options.nix
  ]
  ++ (lib.optional copyChannel ../../../modules/installer/cd-dvd/channel.nix);

  documentation.enable = copyChannel;

  image.extension = format;
  system.nixos.tags = [ "openstack" ];
  system.build.image = config.system.build.openstackImage;
  system.build.openstackImage = import ../../../lib/make-disk-image.nix {
    inherit
      lib
      config
      copyChannel
      format
      ;
    inherit (config.image) baseName;
    additionalSpace = "1024M";
    pkgs = import ../../../.. { inherit (pkgs) system; }; # ensure we use the regular qemu-kvm package
    configFile = pkgs.writeText "configuration.nix" ''
      {
        imports = [ <nixpkgs/nixos/modules/virtualisation/openstack-config.nix> ];
      }
    '';
  };

}
