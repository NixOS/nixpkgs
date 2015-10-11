{ config, lib, pkgs, ... }: with lib;


let
    nonEmptyString = string: if stringLength string > 0 then true else false;
    configFromFile = file: default: findFirst (nonEmptyString) default [
        (if (builtins.pathExists file)
            then builtins.readFile file
            else "")
        ];

    varnishCfg = configFromFile /etc/varnish/default.vcl
            ''
            vcl 4.0;
            backend test {
                .host = "127.0.0.1";
                .port = "8080";
            }
            '';

in

{

    options = {

        flyingcircus.roles.varnish = {

            enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enable the Flying Circus varnish server role.";
            };

        };

    };

    config = mkIf config.flyingcircus.roles.varnish.enable {

        services.varnish.enable = true;
        services.varnish.http_address = "localhost:8008";
        services.varnish.config = varnishCfg;

        jobs.fcio-stubs-varnish = {
            description = "Create FC IO stubs for varnish.";
            task = true;

            startOn = "started networking";

            script =
                ''
                    install -d -o vagrant /etc/varnish
                    touch /etc/varnish/default.vcl
                    chown vagrant: /etc/varnish/default.vcl
                '';
        };

    };
}
