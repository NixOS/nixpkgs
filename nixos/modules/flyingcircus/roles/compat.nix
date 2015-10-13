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
                description = "Enable Flying Circus old-world compatibility.";
            };

        };

    };

    config = mkIf config.flyingcircus.compat.gentoo.enable {

        jobs.fcio-stubs-compat = {
            description = "Create FC IO stubs for gentoo compat.";
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
