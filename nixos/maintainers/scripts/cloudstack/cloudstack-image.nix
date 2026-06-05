# nix-build '<nixpkgs/nixos>' -A config.system.build.cloudstackImage --arg configuration "{ imports = [ ./nixos/maintainers/scripts/cloudstack/cloudstack-image.nix ]; }"

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [

    ../../../modules/virtualisation/cloudstack-config.nix
    ../../../modules/image/file-options.nix
  ];

  system.nixos.tags = [ "cloudstack" ];
  image.extension = "qcow2";
  system.build.image = config.system.build.cloudstackImage;
  system.build.cloudstackImage = import ../../../lib/make-disk-image.nix {
    inherit lib config pkgs;
    inherit (config.virtualisation) diskSize;
    baseName = config.image.baseName;
    format = "qcow2";
    configFile = pkgs.writeText "configuration.nix" ''
      {
        imports = [ <nixpkgs/nixos/modules/virtualisation/cloudstack-config.nix> ];
      }
    '';
  };

}
