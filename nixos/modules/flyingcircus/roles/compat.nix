# Glue for general old-world gentoo compatibility
#
# Note: Currently only makes sense for vagrant.

{ config, lib, pkgs, ... }:
with lib;
{

    options = {

        flyingcircus.compat.gentoo = {

            enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enable Flying Circus Gentoo backwards compatibility.";
            };

        };

    };

    config = mkIf config.flyingcircus.compat.gentoo.enable {

        jobs.flyingcircus-stubs-compat = {
            description = "Create stubs for old Flying Circus Gentoo backwards compatibility.";
            task = true;

            startOn = "started networking";

            script =
                ''
                install -d -o vagrant /etc/nagios/nrpe/local/
                install -d -o vagrant /run/local
                '';
        };

    };
}
