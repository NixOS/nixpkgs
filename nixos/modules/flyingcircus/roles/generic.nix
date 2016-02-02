{ config, lib, pkgs, ... }: with lib;


{

    options = {

        flyingcircus.roles.generic = {

            enable = mkOption {
                type = types.bool;
                default = false;
                description = "Compatibility stub for our old 'generic' role.";
            };

        };

    };

}
